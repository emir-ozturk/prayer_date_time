import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/prayer_times.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../../domain/usecases/get_prayer_times.dart';
import 'prayer_times_event.dart';
import 'prayer_times_state.dart';

class PrayerTimesBloc extends Bloc<PrayerTimesEvent, PrayerTimesState> {
  final GetPrayerTimes getPrayerTimes;
  final PrayerRepository repository;
  Timer? _timer;

  PrayerTimesBloc({required this.getPrayerTimes, required this.repository})
    : super(PrayerTimesInitial()) {
    on<LoadSavedCities>(_onLoadSavedCities);
    on<AddCity>(_onAddCity);
    on<RemoveCity>(_onRemoveCity);
    on<SelectCity>(_onSelectCity);
    on<RefreshPrayerTimes>(_onRefreshPrayerTimes);
    on<StartTimer>(_onStartTimer);
    on<UpdateTimer>(_onUpdateTimer);
  }

  Future<void> _onLoadSavedCities(LoadSavedCities event, Emitter<PrayerTimesState> emit) async {
    try {
      emit(PrayerTimesLoading());
      final savedCities = await repository.getSavedCities();
      final savedCityNames = await repository.getSavedCityNames();
      final savedSelectedCityId = await repository.getSelectedCityId();
      final Map<String, List<PrayerTimes>> citiesPrayerTimes = {};

      for (final districtId in savedCities) {
        final prayerTimes = await getPrayerTimes(districtId);

        // If prayer times are retrieved and have valid data
        if (prayerTimes.isNotEmpty) {
          // If API response has district name, use it; otherwise use saved name
          if (prayerTimes.first.districtName.isNotEmpty) {
            citiesPrayerTimes[districtId] = prayerTimes;
          } else {
            // Create new prayer times with saved district name
            final savedDistrictName = savedCityNames[districtId] ?? 'Bilinmeyen Şehir';
            final updatedPrayerTimes = prayerTimes
                .map(
                  (pt) => PrayerTimes(
                    districtId: pt.districtId,
                    districtName: savedDistrictName,
                    date: pt.date,
                    fajr: pt.fajr,
                    sunrise: pt.sunrise,
                    dhuhr: pt.dhuhr,
                    asr: pt.asr,
                    maghrib: pt.maghrib,
                    isha: pt.isha,
                  ),
                )
                .toList();
            citiesPrayerTimes[districtId] = updatedPrayerTimes;
          }
        }
      }

      // Use saved selected city if it exists and is valid, otherwise use first city
      String? selectedCityId;
      if (savedSelectedCityId != null && citiesPrayerTimes.containsKey(savedSelectedCityId)) {
        selectedCityId = savedSelectedCityId;
      } else if (savedCities.isNotEmpty) {
        selectedCityId = savedCities.first;
        // Save the auto-selected city
        await repository.saveSelectedCityId(selectedCityId);
      }

      emit(
        PrayerTimesLoaded(
          citiesPrayerTimes: citiesPrayerTimes,
          selectedCityId: selectedCityId,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(PrayerTimesError(message: e.toString()));
    }
  }

  Future<void> _onAddCity(AddCity event, Emitter<PrayerTimesState> emit) async {
    try {
      final currentState = state;
      if (currentState is PrayerTimesLoaded) {
        final updatedCities = Map<String, List<PrayerTimes>>.from(currentState.citiesPrayerTimes);

        final prayerTimes = await getPrayerTimes(event.districtId);

        // Create prayer times with correct district name
        final updatedPrayerTimes = prayerTimes
            .map(
              (pt) => PrayerTimes(
                districtId: pt.districtId,
                districtName: event.districtName,
                date: pt.date,
                fajr: pt.fajr,
                sunrise: pt.sunrise,
                dhuhr: pt.dhuhr,
                asr: pt.asr,
                maghrib: pt.maghrib,
                isha: pt.isha,
              ),
            )
            .toList();

        updatedCities[event.districtId] = updatedPrayerTimes;

        final savedCities = await repository.getSavedCities();
        final newSavedCities = [...savedCities, event.districtId];
        await repository.saveCities(newSavedCities);

        // Save city name for future use
        final savedCityNames = await repository.getSavedCityNames();
        savedCityNames[event.districtId] = event.districtName;
        await repository.saveCityNames(savedCityNames);

        // Always select the newly added city
        await repository.saveSelectedCityId(event.districtId);

        emit(
          currentState.copyWith(
            citiesPrayerTimes: updatedCities,
            selectedCityId: event.districtId,
            lastUpdated: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      emit(PrayerTimesError(message: e.toString()));
    }
  }

  Future<void> _onRemoveCity(RemoveCity event, Emitter<PrayerTimesState> emit) async {
    try {
      final currentState = state;
      if (currentState is PrayerTimesLoaded) {
        final updatedCities = Map<String, List<PrayerTimes>>.from(currentState.citiesPrayerTimes);
        updatedCities.remove(event.districtId);

        final savedCities = await repository.getSavedCities();
        final newSavedCities = savedCities.where((id) => id != event.districtId).toList();
        await repository.saveCities(newSavedCities);

        // Remove city name as well
        final savedCityNames = await repository.getSavedCityNames();
        savedCityNames.remove(event.districtId);
        await repository.saveCityNames(savedCityNames);

        // If removed city was selected, select first available or null
        String? newSelectedCityId = currentState.selectedCityId;
        if (newSelectedCityId == event.districtId) {
          newSelectedCityId = updatedCities.keys.isNotEmpty ? updatedCities.keys.first : null;
        }

        // Save the new selected city ID
        await repository.saveSelectedCityId(newSelectedCityId);

        emit(
          currentState.copyWith(
            citiesPrayerTimes: updatedCities,
            selectedCityId: newSelectedCityId,
            lastUpdated: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      emit(PrayerTimesError(message: e.toString()));
    }
  }

  Future<void> _onSelectCity(SelectCity event, Emitter<PrayerTimesState> emit) async {
    final currentState = state;
    if (currentState is PrayerTimesLoaded) {
      // Save the selected city persistently
      await repository.saveSelectedCityId(event.districtId);
      emit(currentState.copyWith(selectedCityId: event.districtId));
    }
  }

  Future<void> _onRefreshPrayerTimes(
    RefreshPrayerTimes event,
    Emitter<PrayerTimesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is PrayerTimesLoaded) {
        final updatedCities = Map<String, List<PrayerTimes>>.from(currentState.citiesPrayerTimes);
        final savedCityNames = await repository.getSavedCityNames();

        final prayerTimes = await getPrayerTimes(event.districtId);

        // Preserve city name when refreshing
        if (prayerTimes.isNotEmpty) {
          final savedDistrictName = savedCityNames[event.districtId];
          if (savedDistrictName != null && savedDistrictName.isNotEmpty) {
            final updatedPrayerTimes = prayerTimes
                .map(
                  (pt) => PrayerTimes(
                    districtId: pt.districtId,
                    districtName: savedDistrictName,
                    date: pt.date,
                    fajr: pt.fajr,
                    sunrise: pt.sunrise,
                    dhuhr: pt.dhuhr,
                    asr: pt.asr,
                    maghrib: pt.maghrib,
                    isha: pt.isha,
                  ),
                )
                .toList();
            updatedCities[event.districtId] = updatedPrayerTimes;
          } else {
            updatedCities[event.districtId] = prayerTimes;
          }
        }

        emit(currentState.copyWith(citiesPrayerTimes: updatedCities, lastUpdated: DateTime.now()));
      }
    } catch (e) {
      emit(PrayerTimesError(message: e.toString()));
    }
  }

  void _onStartTimer(StartTimer event, Emitter<PrayerTimesState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => add(UpdateTimer()));
  }

  void _onUpdateTimer(UpdateTimer event, Emitter<PrayerTimesState> emit) {
    final currentState = state;
    if (currentState is PrayerTimesLoaded) {
      emit(currentState.copyWith(lastUpdated: DateTime.now()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

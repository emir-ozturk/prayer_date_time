import 'package:equatable/equatable.dart';

import '../../domain/entities/prayer_times.dart';

abstract class PrayerTimesState extends Equatable {
  const PrayerTimesState();

  @override
  List<Object> get props => [];
}

class PrayerTimesInitial extends PrayerTimesState {}

class PrayerTimesLoading extends PrayerTimesState {}

class PrayerTimesLoaded extends PrayerTimesState {
  final Map<String, List<PrayerTimes>> citiesPrayerTimes;
  final String? selectedCityId;
  final DateTime lastUpdated;

  const PrayerTimesLoaded({
    required this.citiesPrayerTimes,
    this.selectedCityId,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [citiesPrayerTimes, selectedCityId ?? '', lastUpdated];

  PrayerTimesLoaded copyWith({
    Map<String, List<PrayerTimes>>? citiesPrayerTimes,
    String? selectedCityId,
    DateTime? lastUpdated,
  }) {
    return PrayerTimesLoaded(
      citiesPrayerTimes: citiesPrayerTimes ?? this.citiesPrayerTimes,
      selectedCityId: selectedCityId ?? this.selectedCityId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  List<PrayerTimes>? get selectedCityPrayerTimes {
    if (selectedCityId == null) return null;
    return citiesPrayerTimes[selectedCityId];
  }

  String? get selectedCityName {
    final prayerTimes = selectedCityPrayerTimes;
    if (prayerTimes != null && prayerTimes.isNotEmpty) {
      return prayerTimes.first.districtName;
    }
    return null;
  }
}

class PrayerTimesError extends PrayerTimesState {
  final String message;

  const PrayerTimesError({required this.message});

  @override
  List<Object> get props => [message];
}

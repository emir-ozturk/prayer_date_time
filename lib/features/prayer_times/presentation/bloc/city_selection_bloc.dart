import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/city.dart';
import '../../domain/entities/district.dart';
import '../../domain/usecases/get_cities.dart';
import '../../domain/usecases/get_districts.dart';

// Events
abstract class CitySelectionEvent extends Equatable {
  const CitySelectionEvent();

  @override
  List<Object> get props => [];
}

class LoadCities extends CitySelectionEvent {}

class SelectCity extends CitySelectionEvent {
  final String cityId;

  const SelectCity({required this.cityId});

  @override
  List<Object> get props => [cityId];
}

// States
abstract class CitySelectionState extends Equatable {
  const CitySelectionState();

  @override
  List<Object> get props => [];
}

class CitySelectionInitial extends CitySelectionState {}

class CitySelectionLoading extends CitySelectionState {}

class CitiesLoaded extends CitySelectionState {
  final List<City> cities;

  const CitiesLoaded({required this.cities});

  @override
  List<Object> get props => [cities];
}

class DistrictsLoaded extends CitySelectionState {
  final List<City> cities;
  final List<District> districts;
  final String selectedCityId;

  const DistrictsLoaded({
    required this.cities,
    required this.districts,
    required this.selectedCityId,
  });

  @override
  List<Object> get props => [cities, districts, selectedCityId];
}

class CitySelectionError extends CitySelectionState {
  final String message;

  const CitySelectionError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class CitySelectionBloc extends Bloc<CitySelectionEvent, CitySelectionState> {
  final GetCities getCities;
  final GetDistricts getDistricts;

  CitySelectionBloc({required this.getCities, required this.getDistricts})
    : super(CitySelectionInitial()) {
    on<LoadCities>(_onLoadCities);
    on<SelectCity>(_onSelectCity);
  }

  Future<void> _onLoadCities(LoadCities event, Emitter<CitySelectionState> emit) async {
    try {
      emit(CitySelectionLoading());
      final cities = await getCities();
      emit(CitiesLoaded(cities: cities));
    } catch (e) {
      emit(CitySelectionError(message: e.toString()));
    }
  }

  Future<void> _onSelectCity(SelectCity event, Emitter<CitySelectionState> emit) async {
    try {
      final currentState = state;
      if (currentState is CitiesLoaded) {
        emit(CitySelectionLoading());
        final districts = await getDistricts(event.cityId);
        emit(
          DistrictsLoaded(
            cities: currentState.cities,
            districts: districts,
            selectedCityId: event.cityId,
          ),
        );
      }
    } catch (e) {
      emit(CitySelectionError(message: e.toString()));
    }
  }
}

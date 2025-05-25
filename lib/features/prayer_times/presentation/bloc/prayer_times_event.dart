import 'package:equatable/equatable.dart';

abstract class PrayerTimesEvent extends Equatable {
  const PrayerTimesEvent();

  @override
  List<Object> get props => [];
}

class LoadSavedCities extends PrayerTimesEvent {}

class AddCity extends PrayerTimesEvent {
  final String districtId;
  final String districtName;

  const AddCity({required this.districtId, required this.districtName});

  @override
  List<Object> get props => [districtId, districtName];
}

class RemoveCity extends PrayerTimesEvent {
  final String districtId;

  const RemoveCity({required this.districtId});

  @override
  List<Object> get props => [districtId];
}

class SelectCity extends PrayerTimesEvent {
  final String districtId;

  const SelectCity({required this.districtId});

  @override
  List<Object> get props => [districtId];
}

class RefreshPrayerTimes extends PrayerTimesEvent {
  final String districtId;

  const RefreshPrayerTimes({required this.districtId});

  @override
  List<Object> get props => [districtId];
}

class StartTimer extends PrayerTimesEvent {}

class UpdateTimer extends PrayerTimesEvent {}

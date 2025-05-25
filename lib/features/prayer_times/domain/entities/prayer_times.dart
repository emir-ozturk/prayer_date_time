import 'package:equatable/equatable.dart';

class PrayerTimes extends Equatable {
  final String districtId;
  final String districtName;
  final DateTime date;
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  const PrayerTimes({
    required this.districtId,
    required this.districtName,
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  @override
  List<Object> get props => [
    districtId,
    districtName,
    date,
    fajr,
    sunrise,
    dhuhr,
    asr,
    maghrib,
    isha,
  ];

  @override
  String toString() {
    return 'PrayerTimes(districtId: $districtId, districtName: $districtName, '
        'date: $date, fajr: $fajr, sunrise: $sunrise, dhuhr: $dhuhr, '
        'asr: $asr, maghrib: $maghrib, isha: $isha)';
  }
}

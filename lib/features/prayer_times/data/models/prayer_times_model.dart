import '../../domain/entities/prayer_times.dart';

class PrayerTimesModel extends PrayerTimes {
  const PrayerTimesModel({
    required super.districtId,
    required super.districtName,
    required super.date,
    required super.fajr,
    required super.sunrise,
    required super.dhuhr,
    required super.asr,
    required super.maghrib,
    required super.isha,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimesModel(
      districtId: json['IlceID'].toString(),
      districtName: json['IlceAdi'] ?? '',
      date: _parseDate(json['MiladiTarihKisa']),
      fajr: json['Imsak'] ?? '',
      sunrise: json['Gunes'] ?? '',
      dhuhr: json['Ogle'] ?? '',
      asr: json['Ikindi'] ?? '',
      maghrib: json['Aksam'] ?? '',
      isha: json['Yatsi'] ?? '',
    );
  }

  static DateTime _parseDate(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();

    final dateString = dateValue.toString();

    try {
      // Try ISO format first
      return DateTime.parse(dateString);
    } catch (e) {
      try {
        // Try Turkish format: DD.MM.YYYY
        if (dateString.contains('.')) {
          final parts = dateString.split('.');
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            return DateTime(year, month, day);
          }
        }

        // Try other common formats
        if (dateString.contains('/')) {
          final parts = dateString.split('/');
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            return DateTime(year, month, day);
          }
        }

        // Fallback to current date
        return DateTime.now();
      } catch (e) {
        return DateTime.now();
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'IlceID': districtId,
      'IlceAdi': districtName,
      'MiladiTarihKisa': date.toIso8601String(),
      'Imsak': fajr,
      'Gunes': sunrise,
      'Ogle': dhuhr,
      'Ikindi': asr,
      'Aksam': maghrib,
      'Yatsi': isha,
    };
  }

  factory PrayerTimesModel.fromEntity(PrayerTimes prayerTimes) {
    return PrayerTimesModel(
      districtId: prayerTimes.districtId,
      districtName: prayerTimes.districtName,
      date: prayerTimes.date,
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
    );
  }
}

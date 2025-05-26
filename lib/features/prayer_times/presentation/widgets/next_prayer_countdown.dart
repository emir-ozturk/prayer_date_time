import 'package:flutter/material.dart';

import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/prayer_times.dart';
import 'prayer_info_widget.dart';

class NextPrayerCountdown extends StatelessWidget {
  final PrayerTimes prayerTimes;

  const NextPrayerCountdown({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    final nextPrayer = _getNextPrayer();

    if (nextPrayer == null) {
      return const SizedBox.shrink();
    }

    final timeRemaining = AppDateUtils.getDetailedTimeRemaining(nextPrayer['time']!);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: PrayerInfoWidget(prayerName: nextPrayer['name']!, timeRemaining: timeRemaining),
    );
  }

  Map<String, String>? _getNextPrayer() {
    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    final prayers = [
      {'name': 'İmsak', 'time': prayerTimes.fajr},
      {'name': 'Güneş', 'time': prayerTimes.sunrise},
      {'name': 'Öğle', 'time': prayerTimes.dhuhr},
      {'name': 'İkindi', 'time': prayerTimes.asr},
      {'name': 'Akşam', 'time': prayerTimes.maghrib},
      {'name': 'Yatsı', 'time': prayerTimes.isha},
    ];

    // Find next prayer for today
    for (final prayer in prayers) {
      final prayerTime = prayer['time'];
      if (prayerTime != null && _isTimeAfter(prayerTime, currentTime)) {
        return prayer;
      }
    }

    // If no prayer left today, return first prayer of tomorrow
    return prayers.first;
  }

  bool _isTimeAfter(String time1, String time2) {
    final parts1 = time1.split(':');
    final parts2 = time2.split(':');

    if (parts1.length < 2 || parts2.length < 2) return false;

    final hour1 = int.tryParse(parts1[0]) ?? 0;
    final minute1 = int.tryParse(parts1[1]) ?? 0;
    final hour2 = int.tryParse(parts2[0]) ?? 0;
    final minute2 = int.tryParse(parts2[1]) ?? 0;

    final totalMinutes1 = hour1 * 60 + minute1;
    final totalMinutes2 = hour2 * 60 + minute2;

    return totalMinutes1 > totalMinutes2;
  }
}

import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final time = DateTime(2024, 1, 1, hour, minute);
        return DateFormat('HH:mm').format(time);
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }

  static String getCurrentDateFormatted() {
    try {
      return DateFormat('dd MMMM yyyy', 'tr').format(DateTime.now());
    } catch (e) {
      // Fallback to basic format if locale not available
      return DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
  }

  static String getTimeRemaining(String targetTime) {
    try {
      final now = DateTime.now();
      final parts = targetTime.split(':');
      if (parts.length >= 2) {
        final targetHour = int.parse(parts[0]);
        final targetMinute = int.parse(parts[1]);

        var target = DateTime(now.year, now.month, now.day, targetHour, targetMinute);

        // If target time has passed today, add one day
        if (target.isBefore(now)) {
          target = target.add(const Duration(days: 1));
        }

        final difference = target.difference(now);
        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;

        if (hours > 0) {
          return '${hours}sa ${minutes}dk';
        } else {
          return '${minutes}dk';
        }
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  static String getDetailedTimeRemaining(String targetTime) {
    try {
      final now = DateTime.now();
      final parts = targetTime.split(':');
      if (parts.length >= 2) {
        final targetHour = int.parse(parts[0]);
        final targetMinute = int.parse(parts[1]);

        var target = DateTime(now.year, now.month, now.day, targetHour, targetMinute);

        // If target time has passed today, add one day
        if (target.isBefore(now)) {
          target = target.add(const Duration(days: 1));
        }

        final difference = target.difference(now);
        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;
        final seconds = difference.inSeconds % 60;

        if (hours > 0) {
          return '${hours.toString().padLeft(2, '0')}:'
              '${minutes.toString().padLeft(2, '0')}:'
              '${seconds.toString().padLeft(2, '0')}';
        } else {
          return '${minutes.toString().padLeft(2, '0')}:'
              '${seconds.toString().padLeft(2, '0')}';
        }
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  static String getCurrentPrayerTime(Map<String, String> prayerTimes) {
    try {
      final now = DateTime.now();
      final currentTime =
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}';

      final prayers = [
        {'name': 'İmsak', 'time': prayerTimes['fajr'] ?? ''},
        {'name': 'Güneş', 'time': prayerTimes['sunrise'] ?? ''},
        {'name': 'Öğle', 'time': prayerTimes['dhuhr'] ?? ''},
        {'name': 'İkindi', 'time': prayerTimes['asr'] ?? ''},
        {'name': 'Akşam', 'time': prayerTimes['maghrib'] ?? ''},
        {'name': 'Yatsı', 'time': prayerTimes['isha'] ?? ''},
      ];

      // Find current prayer time
      String currentPrayer = '';
      for (int i = 0; i < prayers.length; i++) {
        final prayer = prayers[i];
        final prayerTime = prayer['time']!;

        if (prayerTime.isEmpty) continue;

        // Check if current time is after this prayer time
        if (_isTimeAfter(currentTime, prayerTime)) {
          currentPrayer = prayer['name']!;
        } else {
          break;
        }
      }

      // If no prayer found (before first prayer), it's the last prayer of previous day
      if (currentPrayer.isEmpty) {
        currentPrayer = 'Yatsı';
      }

      return currentPrayer;
    } catch (e) {
      return '';
    }
  }

  static bool _isTimeAfter(String time1, String time2) {
    try {
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
    } catch (e) {
      return false;
    }
  }

  static bool isDaytime() {
    final now = DateTime.now();
    final hour = now.hour;
    return hour >= 6 && hour < 18; // 6 AM to 6 PM is considered daytime
  }

  /// Determines the animation type based on current prayer time period
  /// Returns: 'night', 'dawn', 'day', or 'sunset'
  static String getPrayerBasedAnimationType(Map<String, String> prayerTimes) {
    try {
      final now = DateTime.now();
      final currentTime =
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}';

      final fajr = prayerTimes['fajr'] ?? '';
      final sunrise = prayerTimes['sunrise'] ?? '';
      final dhuhr = prayerTimes['dhuhr'] ?? '';
      final asr = prayerTimes['asr'] ?? '';
      final maghrib = prayerTimes['maghrib'] ?? '';
      final isha = prayerTimes['isha'] ?? '';

      // Check each prayer time period
      if (isTimeBetween(currentTime, '00:00', fajr) || isTimeBetween(currentTime, isha, '23:59')) {
        return 'night'; // Yatsı - İmsak arası -> night
      } else if (isTimeBetween(currentTime, fajr, sunrise)) {
        return 'night'; // İmsak - Güneş arası -> night
      } else if (isTimeBetween(currentTime, sunrise, dhuhr)) {
        return 'dawn'; // Güneş - Öğle arası -> dawn
      } else if (isTimeBetween(currentTime, dhuhr, asr)) {
        return 'day'; // Öğle - İkindi arası -> day
      } else if (isTimeBetween(currentTime, asr, maghrib)) {
        return 'day'; // İkindi - Akşam arası -> day
      } else if (isTimeBetween(currentTime, maghrib, isha)) {
        return 'sunset'; // Akşam - Yatsı arası -> sunset
      }

      return 'night';
    } catch (e) {
      return 'night';
    }
  }

  /// Checks if time1 is between time2 and time3
  /// All times should be in 24-hour format (HH:mm)
  static bool isTimeBetween(String time1, String time2, String time3) {
    try {
      if (time2.isEmpty || time3.isEmpty) return false;

      final parts1 = time1.split(':');
      final parts2 = time2.split(':');
      final parts3 = time3.split(':');

      if (parts1.length < 2 || parts2.length < 2 || parts3.length < 2) return false;

      final hour1 = int.tryParse(parts1[0]) ?? 0;
      final minute1 = int.tryParse(parts1[1]) ?? 0;
      final hour2 = int.tryParse(parts2[0]) ?? 0;
      final minute2 = int.tryParse(parts2[1]) ?? 0;
      final hour3 = int.tryParse(parts3[0]) ?? 0;
      final minute3 = int.tryParse(parts3[1]) ?? 0;

      final totalMinutes1 = hour1 * 60 + minute1;
      final totalMinutes2 = hour2 * 60 + minute2;
      final totalMinutes3 = hour3 * 60 + minute3;

      if (totalMinutes2 <= totalMinutes3) {
        return totalMinutes1 >= totalMinutes2 && totalMinutes1 < totalMinutes3;
      } else {
        // Handle overnight case (e.g., between 23:00 and 05:00)
        return totalMinutes1 >= totalMinutes2 || totalMinutes1 < totalMinutes3;
      }
    } catch (e) {
      return false;
    }
  }
}

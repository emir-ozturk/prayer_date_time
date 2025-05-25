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

  static bool isTimeNear(String timeString, {int minutesBefore = 15}) {
    try {
      final now = DateTime.now();
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final targetHour = int.parse(parts[0]);
        final targetMinute = int.parse(parts[1]);

        var target = DateTime(now.year, now.month, now.day, targetHour, targetMinute);

        if (target.isBefore(now)) {
          target = target.add(const Duration(days: 1));
        }

        final difference = target.difference(now);
        return difference.inMinutes <= minutesBefore && difference.inMinutes >= 0;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static bool isDaytime() {
    final now = DateTime.now();
    final hour = now.hour;
    return hour >= 6 && hour < 18; // 6 AM to 6 PM is considered daytime
  }

  static String getTimeOfDayGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Günaydın';
    } else if (hour >= 12 && hour < 17) {
      return 'İyi günler';
    } else if (hour >= 17 && hour < 21) {
      return 'İyi akşamlar';
    } else {
      return 'İyi geceler';
    }
  }
}

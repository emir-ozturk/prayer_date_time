import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/prayer_times.dart';

class MonthlyTableRow extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final bool isEven;

  const MonthlyTableRow({super.key, required this.prayerTimes, required this.isEven});

  @override
  Widget build(BuildContext context) {
    final date = prayerTimes.date;
    final dateStr = DateFormat('dd/MM').format(date);
    final dayName = _getTurkishDayName(date.weekday);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: !isEven ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
      ),
      child: Row(
        children: [
          _buildDateCell(dateStr, dayName),
          _buildTimeCell(prayerTimes.fajr),
          _buildTimeCell(prayerTimes.sunrise),
          _buildTimeCell(prayerTimes.dhuhr),
          _buildTimeCell(prayerTimes.asr),
          _buildTimeCell(prayerTimes.maghrib),
          _buildTimeCell(prayerTimes.isha),
        ],
      ),
    );
  }

  String _getTurkishDayName(int weekday) {
    const days = [
      'Pzt', // Monday
      'Sal', // Tuesday
      'Çar', // Wednesday
      'Per', // Thursday
      'Cum', // Friday
      'Cmt', // Saturday
      'Paz', // Sunday
    ];
    return days[weekday - 1];
  }

  Widget _buildDateCell(String dateStr, String dayName) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Text(
            dateStr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            dayName,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCell(String time) {
    return Expanded(
      flex: 2,
      child: Text(
        time,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

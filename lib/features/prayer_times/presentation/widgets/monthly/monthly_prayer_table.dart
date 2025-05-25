import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/prayer_times.dart';
import 'monthly_table_header.dart';
import 'monthly_table_row.dart';

class MonthlyPrayerTable extends StatelessWidget {
  final List<PrayerTimes> monthlyPrayerTimes;

  const MonthlyPrayerTable({super.key, required this.monthlyPrayerTimes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const MonthlyTableHeader(),
          ...monthlyPrayerTimes.asMap().entries.map((entry) {
            final index = entry.key;
            final prayerTimes = entry.value;
            final isEven = index % 2 == 0;
            return MonthlyTableRow(prayerTimes: prayerTimes, isEven: isEven);
          }),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/prayer_times.dart';
import '../widgets/monthly/monthly_prayer_table.dart';

class MonthlyPrayerTimesPage extends StatelessWidget {
  final List<PrayerTimes> monthlyPrayerTimes;
  final String cityName;

  const MonthlyPrayerTimesPage({
    super.key,
    required this.monthlyPrayerTimes,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Son 30 Gün',
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        child: MonthlyPrayerTable(monthlyPrayerTimes: monthlyPrayerTimes),
      ),
    );
  }
}

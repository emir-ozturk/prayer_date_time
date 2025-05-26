import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/prayer_times.dart';
import '../bloc/prayer_times_bloc.dart';
import '../bloc/prayer_times_event.dart';
import '../widgets/monthly/monthly_prayer_table.dart';

class MonthlyPrayerTimesPage extends StatelessWidget {
  final List<PrayerTimes> monthlyPrayerTimes;
  final String cityName;
  final String districtId;

  const MonthlyPrayerTimesPage({
    super.key,
    required this.monthlyPrayerTimes,
    required this.cityName,
    required this.districtId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cityName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontSize: 18,
              ),
            ),
            Text(
              'Aylık Namaz Vakitleri',
              style: TextStyle(color: AppColors.primary.withValues(alpha: 0.7), fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PrayerTimesBloc>().add(RefreshPrayerTimes(districtId: districtId));
            },
          ),
        ],
      ),
      body: monthlyPrayerTimes.isEmpty
          ? const Center(
              child: Text(
                'Namaz vakitleri bulunamadı.\nLütfen yenilemeyi deneyin.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            )
          : SingleChildScrollView(
              child: MonthlyPrayerTable(monthlyPrayerTimes: monthlyPrayerTimes),
            ),
    );
  }
}

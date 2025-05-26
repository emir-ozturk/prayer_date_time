import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prayer_date_time/features/prayer_times/presentation/bloc/prayer_times_bloc.dart';
import 'package:prayer_date_time/features/prayer_times/presentation/bloc/prayer_times_event.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/prayer_times.dart';

class SingleCityPrayerTimes extends StatelessWidget {
  final PrayerTimes prayerTimes;

  const SingleCityPrayerTimes({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 5),
        ],
      ),
      child: Column(children: [_buildHeader(context), _buildPrayerTimesList()]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(AppIcons.dateRange, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppDateUtils.getCurrentDateFormatted(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(AppIcons.refresh, color: Colors.white),
            onPressed: () {
              context.read<PrayerTimesBloc>().add(LoadSavedCities());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesList() {
    final prayers = [
      {'name': 'İmsak', 'time': prayerTimes.fajr, 'icon': AppIcons.fajr, 'color': AppColors.fajr},
      {
        'name': 'Güneş',
        'time': prayerTimes.sunrise,
        'icon': AppIcons.sunrise,
        'color': AppColors.sunrise,
      },
      {'name': 'Öğle', 'time': prayerTimes.dhuhr, 'icon': AppIcons.dhuhr, 'color': AppColors.dhuhr},
      {'name': 'İkindi', 'time': prayerTimes.asr, 'icon': AppIcons.asr, 'color': AppColors.asr},
      {
        'name': 'Akşam',
        'time': prayerTimes.maghrib,
        'icon': AppIcons.maghrib,
        'color': AppColors.maghrib,
      },
      {'name': 'Yatsı', 'time': prayerTimes.isha, 'icon': AppIcons.isha, 'color': AppColors.isha},
    ];

    // Get current prayer time
    final currentPrayerName = AppDateUtils.getCurrentPrayerTime({
      'fajr': prayerTimes.fajr,
      'sunrise': prayerTimes.sunrise,
      'dhuhr': prayerTimes.dhuhr,
      'asr': prayerTimes.asr,
      'maghrib': prayerTimes.maghrib,
      'isha': prayerTimes.isha,
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: prayers.asMap().entries.map((entry) {
          final index = entry.key;
          final prayer = entry.value;
          final isLast = index == prayers.length - 1;

          return Column(
            children: [
              _buildPrayerTimeRow(
                prayer['name'] as String,
                prayer['time'] as String,
                prayer['icon'] as IconData,
                prayer['color'] as Color,
                currentPrayerName,
              ),
              if (!isLast) Divider(color: AppColors.textHint.withValues(alpha: 0.2), height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPrayerTimeRow(
    String name,
    String time,
    IconData icon,
    Color color,
    String currentPrayerName,
  ) {
    final isCurrent = name == currentPrayerName;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: isCurrent ? color.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isCurrent ? color : AppColors.textPrimary,
                  ),
                ),
                if (isCurrent)
                  Text(
                    'Şu anki vakit',
                    style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
          Text(
            AppDateUtils.formatTime(time),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isCurrent ? color : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

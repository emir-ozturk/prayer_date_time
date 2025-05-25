import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/prayer_times.dart';
import '../bloc/prayer_times_bloc.dart';
import '../bloc/prayer_times_event.dart';
import 'next_prayer_countdown.dart';
import 'prayer_time_row.dart';

class PrayerTimeCard extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final String districtId;
  final DateTime lastUpdated;

  const PrayerTimeCard({
    super.key,
    required this.prayerTimes,
    required this.districtId,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            NextPrayerCountdown(prayerTimes: prayerTimes),
            const SizedBox(height: 16),
            _buildPrayerTimes(),
            const SizedBox(height: 12),
            _buildLastUpdated(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Icon(AppIcons.mosque, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prayerTimes.districtName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                AppDateUtils.getCurrentDateFormatted(),
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(AppIcons.delete),
          color: AppColors.error,
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
  }

  Widget _buildPrayerTimes() {
    return Column(
      children: [
        PrayerTimeRow(
          name: 'İmsak',
          time: prayerTimes.fajr,
          icon: AppIcons.fajr,
          color: AppColors.fajr,
        ),
        PrayerTimeRow(
          name: 'Güneş',
          time: prayerTimes.sunrise,
          icon: AppIcons.sunrise,
          color: AppColors.sunrise,
        ),
        PrayerTimeRow(
          name: 'Öğle',
          time: prayerTimes.dhuhr,
          icon: AppIcons.dhuhr,
          color: AppColors.dhuhr,
        ),
        PrayerTimeRow(
          name: 'İkindi',
          time: prayerTimes.asr,
          icon: AppIcons.asr,
          color: AppColors.asr,
        ),
        PrayerTimeRow(
          name: 'Akşam',
          time: prayerTimes.maghrib,
          icon: AppIcons.maghrib,
          color: AppColors.maghrib,
        ),
        PrayerTimeRow(
          name: 'Yatsı',
          time: prayerTimes.isha,
          icon: AppIcons.isha,
          color: AppColors.isha,
        ),
      ],
    );
  }

  Widget _buildLastUpdated() {
    return Row(
      children: [
        const Icon(AppIcons.timer, size: 16, color: AppColors.textHint),
        const SizedBox(width: 4),
        Text(
          'Son güncelleme: ${AppDateUtils.formatTime('${lastUpdated.hour.toString().padLeft(2, '0')}:'
          '${lastUpdated.minute.toString().padLeft(2, '0')}')}',
          style: const TextStyle(fontSize: 12, color: AppColors.textHint),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Şehri Kaldır'),
        content: Text(
          '${prayerTimes.districtName} şehrini listeden kaldırmak istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<PrayerTimesBloc>().add(RemoveCity(districtId: districtId));
            },
            child: const Text('Kaldır'),
          ),
        ],
      ),
    );
  }
}

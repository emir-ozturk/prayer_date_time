import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/prayer_times.dart';

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
          '$cityName - Son 30 Gün',
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(child: _buildPrayerTimesTable()),
    );
  }

  Widget _buildPrayerTimesTable() {
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
          _buildTableHeader(),
          ...monthlyPrayerTimes.asMap().entries.map((entry) {
            final index = entry.key;
            final prayerTimes = entry.value;
            final isEven = index % 2 == 0;
            return _buildTableRow(prayerTimes, isEven);
          }),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Tarih', flex: 2),
          _buildHeaderCell('İmsak', flex: 2),
          _buildHeaderCell('Güneş', flex: 2),
          _buildHeaderCell('Öğle', flex: 2),
          _buildHeaderCell('İkindi', flex: 2),
          _buildHeaderCell('Akşam', flex: 2),
          _buildHeaderCell('Yatsı', flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableRow(PrayerTimes prayerTimes, bool isEven) {
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

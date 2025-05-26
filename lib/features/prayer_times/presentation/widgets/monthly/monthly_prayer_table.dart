import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/prayer_times.dart';

class MonthlyPrayerTable extends StatelessWidget {
  final List<PrayerTimes> monthlyPrayerTimes;

  const MonthlyPrayerTable({super.key, required this.monthlyPrayerTimes});

  @override
  Widget build(BuildContext context) {
    // Sort prayer times by date
    final sortedPrayerTimes = List<PrayerTimes>.from(monthlyPrayerTimes)
      ..sort((a, b) => a.date.compareTo(b.date));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTableHeader(),
            const SizedBox(height: 8),
            ...sortedPrayerTimes.map((prayerTime) => _buildTableRow(prayerTime)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Tarih', width: 100),
          _buildHeaderCell('İmsak', width: 80),
          _buildHeaderCell('Güneş', width: 80),
          _buildHeaderCell('Öğle', width: 80),
          _buildHeaderCell('İkindi', width: 80),
          _buildHeaderCell('Akşam', width: 80),
          _buildHeaderCell('Yatsı', width: 80),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {required double width}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableRow(PrayerTimes prayerTime) {
    final isToday = _isToday(prayerTime.date);
    final backgroundColor = isToday ? AppColors.primary.withOpacity(0.1) : Colors.transparent;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1)),
      ),
      child: Row(
        children: [
          _buildCell(_formatDate(prayerTime.date), width: 100, isToday: isToday),
          _buildCell(prayerTime.fajr, width: 80, isToday: isToday),
          _buildCell(prayerTime.sunrise, width: 80, isToday: isToday),
          _buildCell(prayerTime.dhuhr, width: 80, isToday: isToday),
          _buildCell(prayerTime.asr, width: 80, isToday: isToday),
          _buildCell(prayerTime.maghrib, width: 80, isToday: isToday),
          _buildCell(prayerTime.isha, width: 80, isToday: isToday),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {required double width, bool isToday = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          color: isToday ? AppColors.primary : Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}

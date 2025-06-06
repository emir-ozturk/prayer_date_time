import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../domain/entities/prayer_times.dart';
import '../pages/monthly_prayer_times_page.dart';

class MonthlyViewButton extends StatelessWidget {
  final List<PrayerTimes> monthlyPrayerTimes;
  final String cityName;
  final String districtId;

  const MonthlyViewButton({
    super.key,
    required this.monthlyPrayerTimes,
    required this.cityName,
    required this.districtId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _navigateToMonthlyView(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 16),
                Expanded(child: _buildContent()),
                const SizedBox(width: 12),
                _buildArrow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 1),
      ),
      child: const Icon(AppIcons.schedule, color: AppColors.primary, size: 24),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Aylık Vakitler',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Son 30 Gün',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildArrow() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.chevron_right, color: AppColors.primary.withValues(alpha: 0.7), size: 18),
    );
  }

  void _navigateToMonthlyView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MonthlyPrayerTimesPage(
          monthlyPrayerTimes: monthlyPrayerTimes,
          cityName: cityName,
          districtId: districtId,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/prayer_times.dart';
import '../../bloc/prayer_times_bloc.dart';
import '../../bloc/prayer_times_event.dart';
import '../monthly_view_button.dart';
import '../next_prayer_countdown.dart';
import '../single_city_prayer_times.dart';

class HomePrayerTimesContent extends StatelessWidget {
  final List<PrayerTimes> selectedCityPrayerTimes;

  const HomePrayerTimesContent({super.key, required this.selectedCityPrayerTimes});

  @override
  Widget build(BuildContext context) {
    final todaysPrayerTimes = _getTodayPrayerTimes(context, selectedCityPrayerTimes);

    if (todaysPrayerTimes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final cityName = todaysPrayerTimes.districtName;
    final districtId = todaysPrayerTimes.districtId;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 170, bottom: 100),
      child: Column(
        spacing: 15,
        children: [
          NextPrayerCountdown(prayerTimes: todaysPrayerTimes),
          SingleCityPrayerTimes(prayerTimes: todaysPrayerTimes),
          MonthlyViewButton(
            monthlyPrayerTimes: selectedCityPrayerTimes,
            cityName: cityName,
            districtId: districtId,
          ),
        ],
      ),
    );
  }

  PrayerTimes? _getTodayPrayerTimes(BuildContext context, List<PrayerTimes> prayerTimesList) {
    final today = DateTime.now();

    // Try to find today's prayer times
    for (final prayerTimes in prayerTimesList) {
      if (prayerTimes.date.day == today.day &&
          prayerTimes.date.month == today.month &&
          prayerTimes.date.year == today.year) {
        return prayerTimes;
      }
    }

    // If today's prayer times are not found, trigger a refresh and return null
    if (prayerTimesList.isNotEmpty) {
      context.read<PrayerTimesBloc>().add(
        RefreshPrayerTimes(districtId: prayerTimesList.first.districtId),
      );
    }
    return null;
  }
}

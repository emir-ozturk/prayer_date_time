import 'package:flutter/material.dart';

import '../../../domain/entities/prayer_times.dart';
import '../monthly_view_button.dart';
import '../next_prayer_countdown.dart';
import '../single_city_prayer_times.dart';

class HomePrayerTimesContent extends StatelessWidget {
  final List<PrayerTimes> selectedCityPrayerTimes;

  const HomePrayerTimesContent({super.key, required this.selectedCityPrayerTimes});

  @override
  Widget build(BuildContext context) {
    final todaysPrayerTimes = selectedCityPrayerTimes.first;
    final cityName = todaysPrayerTimes.districtName;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 170, bottom: 100),
      child: Column(
        spacing: 15,
        children: [
          NextPrayerCountdown(prayerTimes: todaysPrayerTimes),
          SingleCityPrayerTimes(prayerTimes: todaysPrayerTimes),
          MonthlyViewButton(monthlyPrayerTimes: selectedCityPrayerTimes, cityName: cityName),
        ],
      ),
    );
  }
}

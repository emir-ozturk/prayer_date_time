import 'package:flutter/material.dart';

import '../../bloc/prayer_times_state.dart';
import 'drawer_city_item.dart';

class DrawerCityList extends StatelessWidget {
  final PrayerTimesLoaded state;

  const DrawerCityList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        const SizedBox(),
        ...state.citiesPrayerTimes.entries.map((entry) {
          final districtId = entry.key;
          final prayerTimes = entry.value;

          if (prayerTimes.isEmpty) return const SizedBox.shrink();

          final cityName = prayerTimes.first.districtName;
          final isSelected = state.selectedCityId == districtId;

          return DrawerCityItem(districtId: districtId, cityName: cityName, isSelected: isSelected);
        }),
      ],
    );
  }
}

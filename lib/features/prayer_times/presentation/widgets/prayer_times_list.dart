import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/prayer_times.dart';
import '../bloc/prayer_times_bloc.dart';
import '../bloc/prayer_times_event.dart';
import 'prayer_time_card.dart';

class PrayerTimesList extends StatelessWidget {
  final Map<String, List<PrayerTimes>> citiesPrayerTimes;
  final DateTime lastUpdated;

  const PrayerTimesList({super.key, required this.citiesPrayerTimes, required this.lastUpdated});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: citiesPrayerTimes.length,
      itemBuilder: (context, index) {
        final entry = citiesPrayerTimes.entries.elementAt(index);
        final districtId = entry.key;
        final prayerTimesList = entry.value;

        if (prayerTimesList.isEmpty) {
          return const SizedBox.shrink();
        }

        final todayPrayerTimes = _getTodayPrayerTimes(context, prayerTimesList, districtId);
        if (todayPrayerTimes == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return PrayerTimeCard(
          prayerTimes: todayPrayerTimes,
          districtId: districtId,
          lastUpdated: lastUpdated,
        );
      },
    );
  }

  PrayerTimes? _getTodayPrayerTimes(
    BuildContext context,
    List<PrayerTimes> prayerTimesList,
    String districtId,
  ) {
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
    context.read<PrayerTimesBloc>().add(RefreshPrayerTimes(districtId: districtId));
    return null;
  }
}

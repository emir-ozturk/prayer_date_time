import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/prayer_times.dart';
import '../bloc/prayer_times_bloc.dart';
import '../bloc/prayer_times_state.dart';
import '../widgets/add_city_fab.dart';
import '../widgets/animated_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/home/home_app_bar_actions.dart';
import '../widgets/home/home_app_bar_title.dart';
import '../widgets/home/home_body_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: false,
        title: const HomeAppBarTitle(),
        actions: HomeAppBarActions.build(context),
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
        builder: (context, state) {
          Map<String, String>? prayerTimes;

          if (state is PrayerTimesLoaded) {
            final selectedCityPrayerTimes = state.selectedCityPrayerTimes;
            if (selectedCityPrayerTimes != null && selectedCityPrayerTimes.isNotEmpty) {
              final todayPrayerTimes = _getTodayPrayerTimes(selectedCityPrayerTimes);
              if (todayPrayerTimes != null) {
                prayerTimes = {
                  'fajr': todayPrayerTimes.fajr,
                  'sunrise': todayPrayerTimes.sunrise,
                  'dhuhr': todayPrayerTimes.dhuhr,
                  'asr': todayPrayerTimes.asr,
                  'maghrib': todayPrayerTimes.maghrib,
                  'isha': todayPrayerTimes.isha,
                };
              }
            }
          }

          return AnimatedBackground(prayerTimes: prayerTimes, child: const HomeBodyContent());
        },
      ),
      floatingActionButton: const AddCityFab(),
    );
  }

  PrayerTimes? _getTodayPrayerTimes(List<PrayerTimes> prayerTimesList) {
    final today = DateTime.now();

    // Try to find today's prayer times
    for (final prayerTimes in prayerTimesList) {
      if (prayerTimes.date.day == today.day &&
          prayerTimes.date.month == today.month &&
          prayerTimes.date.year == today.year) {
        return prayerTimes;
      }
    }

    // If not found, return the first available
    return prayerTimesList.isNotEmpty ? prayerTimesList.first : null;
  }
}

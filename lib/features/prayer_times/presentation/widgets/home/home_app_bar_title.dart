import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prayer_date_time/core/extensions/string_extensions.dart';

import '../../bloc/prayer_times_bloc.dart';
import '../../bloc/prayer_times_state.dart';

class HomeAppBarTitle extends StatelessWidget {
  const HomeAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
      builder: (context, state) {
        if (state is PrayerTimesLoaded &&
            state.selectedCityPrayerTimes != null &&
            state.selectedCityPrayerTimes!.isNotEmpty) {
          final cityName = state.selectedCityPrayerTimes!.first.districtName;
          return Text(
            cityName.toTitleCase,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

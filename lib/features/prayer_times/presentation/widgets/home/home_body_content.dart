import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/prayer_times_bloc.dart';
import '../../bloc/prayer_times_event.dart';
import '../../bloc/prayer_times_state.dart';
import 'home_empty_cities_state.dart';
import 'home_error_state.dart';
import 'home_no_city_data_state.dart';
import 'home_prayer_times_content.dart';

class HomeBodyContent extends StatelessWidget {
  const HomeBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
      builder: (context, state) {
        if (state is PrayerTimesInitial) {
          context.read<PrayerTimesBloc>().add(LoadSavedCities());
          context.read<PrayerTimesBloc>().add(StartTimer());
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        if (state is PrayerTimesLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        if (state is PrayerTimesError) {
          return HomeErrorState(errorMessage: state.message);
        }

        if (state is PrayerTimesLoaded) {
          if (state.citiesPrayerTimes.isEmpty) {
            return const HomeEmptyCitiesState();
          }

          final selectedCityPrayerTimes = state.selectedCityPrayerTimes;
          if (selectedCityPrayerTimes == null || selectedCityPrayerTimes.isEmpty) {
            return const HomeNoCityDataState();
          }

          return HomePrayerTimesContent(selectedCityPrayerTimes: selectedCityPrayerTimes);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../bloc/prayer_times_bloc.dart';
import '../bloc/prayer_times_event.dart';
import '../bloc/prayer_times_state.dart';
import '../widgets/add_city_fab.dart';
import '../widgets/animated_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/monthly_view_button.dart';
import '../widgets/next_prayer_countdown.dart';
import '../widgets/single_city_prayer_times.dart';

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
        title: BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
          builder: (context, state) {
            if (state is PrayerTimesLoaded &&
                state.selectedCityPrayerTimes != null &&
                state.selectedCityPrayerTimes!.isNotEmpty) {
              final cityName = state.selectedCityPrayerTimes!.first.districtName;
              return Text(
                cityName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.refresh, color: Colors.white),
            onPressed: () {
              context.read<PrayerTimesBloc>().add(LoadSavedCities());
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: AnimatedBackground(
        child: BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Icon(AppIcons.error, size: 64, color: AppColors.error),
                          const SizedBox(height: 16),
                          Text(
                            'Hata: ${state.message}',
                            style: const TextStyle(color: AppColors.error),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<PrayerTimesBloc>().add(LoadSavedCities());
                            },
                            child: const Text('Tekrar Dene'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is PrayerTimesLoaded) {
              if (state.citiesPrayerTimes.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(AppIcons.mosque, size: 64, color: AppColors.primary),
                        SizedBox(height: 16),
                        Text(
                          'Henüz şehir eklenmemiş',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sağ alttaki + butonuna basarak\nşehir ekleyin',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show selected city or first city if none selected
              final selectedCityPrayerTimes = state.selectedCityPrayerTimes;
              if (selectedCityPrayerTimes == null || selectedCityPrayerTimes.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(AppIcons.error, size: 64, color: AppColors.error),
                        SizedBox(height: 16),
                        Text(
                          'Şehir verisi bulunamadı',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lütfen şehir ekleyin veya yeniden deneyin',
                          style: TextStyle(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final todaysPrayerTimes = selectedCityPrayerTimes.first;
              final cityName = todaysPrayerTimes.districtName;

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
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: const AddCityFab(),
    );
  }
}

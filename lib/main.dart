import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'features/prayer_times/presentation/bloc/background_animation_bloc.dart';
import 'features/prayer_times/presentation/bloc/city_selection_bloc.dart';
import 'features/prayer_times/presentation/bloc/prayer_times_bloc.dart';
import 'features/prayer_times/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  final serviceLocator = ServiceLocator();
  await serviceLocator.init();

  runApp(PrayerTimesApp(serviceLocator: serviceLocator));
}

class PrayerTimesApp extends StatelessWidget {
  final ServiceLocator serviceLocator;

  const PrayerTimesApp({super.key, required this.serviceLocator});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PrayerTimesBloc>(
          create: (context) => PrayerTimesBloc(
            getPrayerTimes: serviceLocator.getPrayerTimes,
            repository: serviceLocator.prayerRepository,
          ),
        ),
        BlocProvider<CitySelectionBloc>(
          create: (context) => CitySelectionBloc(
            getCities: serviceLocator.getCities,
            getDistricts: serviceLocator.getDistricts,
          ),
        ),
        BlocProvider<BackgroundAnimationBloc>(create: (context) => BackgroundAnimationBloc()),
      ],
      child: MaterialApp(
        title: 'Namaz Vakitleri',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/prayer_times_bloc.dart';
import '../bloc/prayer_times_state.dart';
import '../widgets/add_city_fab.dart';
import '../widgets/animated_background.dart';
import '../widgets/app_drawer.dart';
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
        // actions: HomeAppBarActions.build(context),
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
        builder: (context, state) {
          return const AnimatedBackground(child: HomeBodyContent());
        },
      ),
      floatingActionButton: const AddCityFab(),
    );
  }
}

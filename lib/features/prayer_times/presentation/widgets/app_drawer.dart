import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/prayer_times_bloc.dart';
import '../bloc/prayer_times_state.dart';
import 'drawer/drawer_city_list.dart';
import 'drawer/drawer_empty_state.dart';
import 'drawer/drawer_header.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
        builder: (context, state) {
          return Column(
            children: [
              const AppDrawerHeader(),
              Expanded(child: _buildContent(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PrayerTimesState state) {
    if (state is! PrayerTimesLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.citiesPrayerTimes.isEmpty) {
      return const DrawerEmptyState();
    }

    return DrawerCityList(state: state);
  }
}

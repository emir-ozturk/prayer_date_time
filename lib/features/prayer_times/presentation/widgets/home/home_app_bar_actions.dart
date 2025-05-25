import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../bloc/prayer_times_bloc.dart';
import '../../bloc/prayer_times_event.dart';

class HomeAppBarActions {
  static List<Widget> build(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(AppIcons.refresh, color: Colors.white),
        onPressed: () {
          context.read<PrayerTimesBloc>().add(LoadSavedCities());
        },
      ),
    ];
  }
}

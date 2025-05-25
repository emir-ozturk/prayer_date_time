import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../bloc/prayer_times_bloc.dart';
import '../../bloc/prayer_times_event.dart';

class HomeErrorState extends StatelessWidget {
  final String errorMessage;

  const HomeErrorState({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(AppIcons.error, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Text(
                  'Hata: $errorMessage',
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
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/prayer_times.dart';
import '../bloc/background_animation_bloc.dart';
import '../bloc/background_animation_event.dart';
import '../bloc/background_animation_state.dart';
import '../bloc/prayer_times_bloc.dart';
import '../bloc/prayer_times_state.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with TickerProviderStateMixin {
  late AnimationController _sunController;
  late AnimationController _moonController;
  late AnimationController _starsController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    _sunController = AnimationController(duration: const Duration(seconds: 10), vsync: this)
      ..repeat();

    _moonController = AnimationController(duration: const Duration(seconds: 15), vsync: this)
      ..repeat();

    _starsController = AnimationController(duration: const Duration(seconds: 3), vsync: this)
      ..repeat(reverse: true);

    // Start the background animation timer
    context.read<BackgroundAnimationBloc>().add(StartBackgroundAnimationTimer());
  }

  @override
  void dispose() {
    _sunController.dispose();
    _moonController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrayerTimesBloc, PrayerTimesState>(
      listener: (context, state) {
        if (state is PrayerTimesLoaded) {
          final selectedCityPrayerTimes = state.selectedCityPrayerTimes;
          if (selectedCityPrayerTimes != null && selectedCityPrayerTimes.isNotEmpty) {
            final todayPrayerTimes = _getTodayPrayerTimes(selectedCityPrayerTimes);
            if (todayPrayerTimes != null) {
              _isInitialized = true;
              context.read<BackgroundAnimationBloc>().add(
                UpdateBackgroundAnimation(
                  currentTime: DateTime.now(),
                  prayerTimes: {
                    'fajr': todayPrayerTimes.fajr,
                    'sunrise': todayPrayerTimes.sunrise,
                    'dhuhr': todayPrayerTimes.dhuhr,
                    'asr': todayPrayerTimes.asr,
                    'maghrib': todayPrayerTimes.maghrib,
                    'isha': todayPrayerTimes.isha,
                  },
                ),
              );
            }
          }
        }
      },
      child: BlocBuilder<BackgroundAnimationBloc, BackgroundAnimationState>(
        builder: (context, state) {
          if (!_isInitialized || state is BackgroundAnimationInitial) {
            return Container(color: Colors.white, child: widget.child);
          }

          String animationType = 'night';
          if (state is BackgroundAnimationUpdate) {
            animationType = state.animationType;
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _getColorsForAnimationType(animationType),
              ),
            ),
            child: Stack(
              children: [
                if (animationType == 'dawn' || animationType == 'day') ..._buildDaytimeElements(),
                if (animationType == 'night' || animationType == 'sunset')
                  ..._buildNighttimeElements(),
                widget.child,
              ],
            ),
          );
        },
      ),
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

    return prayerTimesList.isNotEmpty ? prayerTimesList.first : null;
  }

  List<Color> _getColorsForAnimationType(String animationType) {
    switch (animationType) {
      case 'dawn':
        return [
          const Color(0xFFFFB347), // Orange
          const Color(0xFFFFD700), // Gold
          const Color(0xFF87CEEB), // Sky blue
        ];
      case 'day':
        return [
          const Color(0xFF87CEEB), // Sky blue
          const Color(0xFF98D8E8), // Light blue
          const Color(0xFFE6F3FF), // Very light blue
        ];
      case 'sunset':
        return [
          const Color(0xFFFF6B6B), // Red
          const Color(0xFFFFD93D), // Yellow
          const Color.fromARGB(255, 255, 177, 95), // Light orange
        ];
      case 'night':
      default:
        return [
          const Color(0xFF191970), // Midnight blue
          const Color(0xFF483D8B), // Dark slate blue
          const Color(0xFF2F2F4F), // Dark slate gray
        ];
    }
  }

  List<Widget> _buildDaytimeElements() {
    return [
      // Sun
      AnimatedBuilder(
        animation: _sunController,
        builder: (context, child) {
          return Positioned(
            top: 50 + math.sin(_sunController.value * 2 * math.pi) * 20,
            right: 50 + math.cos(_sunController.value * 2 * math.pi) * 30,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [Colors.yellow.shade300, Colors.orange.shade400]),
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // Clouds
      ..._buildClouds(),
    ];
  }

  List<Widget> _buildNighttimeElements() {
    return [
      // Moon
      AnimatedBuilder(
        animation: _moonController,
        builder: (context, child) {
          return Positioned(
            top: 80 + math.sin(_moonController.value * 2 * math.pi) * 15,
            right: 60 + math.cos(_moonController.value * 2 * math.pi) * 25,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [Colors.grey.shade200, Colors.grey.shade400]),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.2),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // Stars
      ..._buildStars(),
    ];
  }

  List<Widget> _buildClouds() {
    return [
      Positioned(
        top: 100,
        left: 20,
        child: AnimatedBuilder(
          animation: _sunController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_sunController.value * 50 - 25, 0),
              child: Icon(Icons.cloud, size: 40, color: Colors.white.withValues(alpha: 0.7)),
            );
          },
        ),
      ),
      Positioned(
        top: 120,
        right: 80,
        child: AnimatedBuilder(
          animation: _sunController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(-_sunController.value * 30 + 15, 0),
              child: Icon(Icons.cloud, size: 30, color: Colors.white.withValues(alpha: 0.5)),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _buildStars() {
    return List.generate(15, (index) {
      return Positioned(
        top: 50 + (index * 23) % 200,
        left: 30 + (index * 47) % 300,
        child: AnimatedBuilder(
          animation: _starsController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.3 + (_starsController.value * 0.7),
              child: Icon(Icons.star, size: 8 + (index % 3) * 4, color: Colors.white),
            );
          },
        ),
      );
    });
  }
}

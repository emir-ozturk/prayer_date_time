import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_utils.dart';
import 'background_animation_event.dart';
import 'background_animation_state.dart';

class BackgroundAnimationBloc extends Bloc<BackgroundAnimationEvent, BackgroundAnimationState> {
  Timer? _timer;

  BackgroundAnimationBloc() : super(BackgroundAnimationInitial()) {
    on<StartBackgroundAnimationTimer>(_onStartTimer);
    on<UpdateBackgroundAnimation>(_onUpdateAnimation);
  }

  String _determineAnimationType(Map<String, String> prayerTimes) {
    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final fajr = prayerTimes['fajr'] ?? '';
    final sunrise = prayerTimes['sunrise'] ?? '';
    final dhuhr = prayerTimes['dhuhr'] ?? '';
    final asr = prayerTimes['asr'] ?? '';
    final maghrib = prayerTimes['maghrib'] ?? '';
    final isha = prayerTimes['isha'] ?? '';

    // Check each prayer time period
    if (AppDateUtils.isTimeBetween(currentTime, '00:00', fajr) ||
        AppDateUtils.isTimeBetween(currentTime, isha, '23:59')) {
      return 'night'; // Yatsı - İmsak arası -> night
    } else if (AppDateUtils.isTimeBetween(currentTime, fajr, sunrise)) {
      return 'night'; // İmsak - Güneş arası -> night
    } else if (AppDateUtils.isTimeBetween(currentTime, sunrise, dhuhr)) {
      return 'dawn'; // Güneş - Öğle arası -> dawn
    } else if (AppDateUtils.isTimeBetween(currentTime, dhuhr, asr)) {
      return 'day'; // Öğle - İkindi arası -> day
    } else if (AppDateUtils.isTimeBetween(currentTime, asr, maghrib)) {
      return 'day'; // İkindi - Akşam arası -> day
    } else if (AppDateUtils.isTimeBetween(currentTime, maghrib, isha)) {
      return 'sunset'; // Akşam - Yatsı arası -> sunset
    }

    return 'night';
  }

  void _onStartTimer(StartBackgroundAnimationTimer event, Emitter<BackgroundAnimationState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      final currentState = state;
      if (currentState is BackgroundAnimationUpdate) {
        add(
          UpdateBackgroundAnimation(
            currentTime: DateTime.now(),
            prayerTimes: currentState.prayerTimes,
          ),
        );
      }
    });
  }

  void _onUpdateAnimation(UpdateBackgroundAnimation event, Emitter<BackgroundAnimationState> emit) {
    final animationType = _determineAnimationType(event.prayerTimes);
    emit(
      BackgroundAnimationUpdate(
        animationType: animationType,
        lastUpdated: event.currentTime,
        prayerTimes: event.prayerTimes,
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

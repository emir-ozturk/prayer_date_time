import 'package:equatable/equatable.dart';

abstract class BackgroundAnimationEvent extends Equatable {
  const BackgroundAnimationEvent();

  @override
  List<Object> get props => [];
}

class UpdateBackgroundAnimation extends BackgroundAnimationEvent {
  final DateTime currentTime;
  final Map<String, String> prayerTimes;

  const UpdateBackgroundAnimation({required this.currentTime, required this.prayerTimes});

  @override
  List<Object> get props => [currentTime, prayerTimes];
}

class StartBackgroundAnimationTimer extends BackgroundAnimationEvent {}

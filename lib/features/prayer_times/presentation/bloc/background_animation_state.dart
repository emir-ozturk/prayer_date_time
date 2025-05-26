import 'package:equatable/equatable.dart';

abstract class BackgroundAnimationState extends Equatable {
  const BackgroundAnimationState();

  @override
  List<Object> get props => [];
}

class BackgroundAnimationInitial extends BackgroundAnimationState {}

class BackgroundAnimationUpdate extends BackgroundAnimationState {
  final String animationType;
  final DateTime lastUpdated;
  final Map<String, String> prayerTimes;

  const BackgroundAnimationUpdate({
    required this.animationType,
    required this.lastUpdated,
    required this.prayerTimes,
  });

  @override
  List<Object> get props => [animationType, lastUpdated, prayerTimes];
}

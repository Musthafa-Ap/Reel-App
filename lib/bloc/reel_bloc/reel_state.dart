// reel_state.dart
import 'package:video_player/video_player.dart';

abstract class ReelState {}

class ReelLoading extends ReelState {}

class ReelLoadedState extends ReelState {
  final List<VideoPlayerController> controllers;
  final int currentIndex;
  ReelLoadedState(this.controllers, this.currentIndex);
}

class ReelErrorState extends ReelState {
  final String message;
  ReelErrorState(this.message);
}

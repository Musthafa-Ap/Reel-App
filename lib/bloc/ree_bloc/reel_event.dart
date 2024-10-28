// reel_event.dart
abstract class ReelEvent {}

class LoadVideosEvent extends ReelEvent {}

class PlayVideoEvent extends ReelEvent {
  final int index;
  PlayVideoEvent(this.index);
}

class PauseVideoEvent extends ReelEvent {
  final int index;
  PauseVideoEvent(this.index);
}

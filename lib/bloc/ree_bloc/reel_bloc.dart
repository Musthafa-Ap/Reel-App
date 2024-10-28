import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reel_app/bloc/ree_bloc/reel_event.dart';
import 'package:reel_app/bloc/ree_bloc/reel_state.dart';
import 'package:video_player/video_player.dart';

class ReelBloc extends Bloc<ReelEvent, ReelState> {
  final List<String> videoUrls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
    'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_20mb.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
  ];
  List<VideoPlayerController> _controllers = [];

  ReelBloc() : super(ReelLoading()) {
    on<LoadVideosEvent>((event, emit) async {
      try {
        _controllers = videoUrls.map((url) {
          final controller = VideoPlayerController.networkUrl(Uri.parse(url));
          return controller;
        }).toList();
        await Future.wait(_controllers.map((c) => c.initialize()));
        emit(ReelLoadedState(_controllers, 0));
      } catch (e) {
        emit(ReelErrorState('Failed to load videos'));
      }
    });

    on<PlayVideoEvent>((event, emit) {
      if (state is ReelLoadedState) {
        final currentState = state as ReelLoadedState;
        final currentController =
            currentState.controllers[currentState.currentIndex];
        currentController.pause();
        final newController = currentState.controllers[event.index];
        newController.play();
        emit(ReelLoadedState(currentState.controllers, event.index));
      }
    });

    on<PauseVideoEvent>((event, emit) {
      if (state is ReelLoadedState) {
        final currentState = state as ReelLoadedState;
        final controller = currentState.controllers[event.index];
        controller.pause();
        emit(ReelLoadedState(currentState.controllers, event.index));
      }
    });
  }

  @override
  Future<void> close() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    return super.close();
  }
}

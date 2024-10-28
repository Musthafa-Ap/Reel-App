import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../bloc/ree_bloc/reel_bloc.dart';
import '../bloc/ree_bloc/reel_event.dart';
import '../bloc/ree_bloc/reel_state.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReelBloc>().add(LoadVideosEvent());
  }

  @override
  Widget build(BuildContext context) {
    ReelBloc reelBloc = context.read<ReelBloc>();
    return BlocBuilder<ReelBloc, ReelState>(
      builder: (context, state) {
        if (state is ReelLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReelLoadedState) {
          List<VideoPlayerController> controllers = state.controllers;
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controllers.length,
            onPageChanged: (index) {
              reelBloc.add(PlayVideoEvent(index));
            },
            itemBuilder: (context, index) {
              return VisibilityDetector(
                key: Key('video_$index'),
                onVisibilityChanged: (visibilityInfo) {
                  if (visibilityInfo.visibleFraction > 0.8) {
                    reelBloc.add(PlayVideoEvent(index));
                  }
                },
                child: controllers[index].value.isInitialized
                    ? GestureDetector(
                        onTap: () {
                          if (controllers[index].value.isPlaying) {
                            reelBloc.add(PauseVideoEvent(index));
                          } else {
                            reelBloc.add(PlayVideoEvent(index));
                          }
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            AspectRatio(
                              aspectRatio: controllers[index].value.aspectRatio,
                              child: VideoPlayer(controllers[index]),
                            ),
                            if (!controllers[index].value.isPlaying)
                              const Icon(
                                Icons.play_circle_filled,
                                size: 60,
                                color: Colors.black,
                              )
                          ],
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              );
            },
          );
        } else if (state is ReelErrorState) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

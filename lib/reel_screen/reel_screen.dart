import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reel_app/bloc/upload_bloc/upload_bloc.dart';
import 'package:reel_app/bloc/upload_bloc/upload_state.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../bloc/reel_bloc/reel_bloc.dart';
import '../bloc/reel_bloc/reel_event.dart';
import '../bloc/reel_bloc/reel_state.dart';
import '../bloc/upload_bloc/upload_event.dart';

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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: BlocConsumer<UploadBloc, UploadState>(
        listener: (context, state) {
          if (state is UploadErrorState) {
            log('-----------Error-------------');
          } else if (state is UploadSuccessState) {
            reelBloc.add(LoadVideosEvent());
          }
        },
        builder: (context, state) {
          if (state is UploadLoadingState) {
            return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3,
                horizontal: 7,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4), color: Colors.white),
              child: const Text(
                'Uploading...',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return IconButton(
              onPressed: () {
                context.read<UploadBloc>().add(VideoUploadEvent());
              },
              icon: const Icon(
                Icons.upload,
                size: 35,
                color: Colors.black,
              ),
            );
          }
        },
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<ReelBloc, ReelState>(
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
                                aspectRatio:
                                    controllers[index].value.aspectRatio,
                                child: VideoPlayer(controllers[index]),
                              ),
                              if (!controllers[index].value.isPlaying)
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.black,
                                      size: 35,
                                    ),
                                  ),
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
      ),
    );
  }
}

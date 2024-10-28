import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reel_app/bloc/upload_bloc/upload_event.dart';
import 'package:reel_app/bloc/upload_bloc/upload_state.dart';
import 'package:reel_app/repository/upload_repository.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc() : super(UploadState()) {
    on<VideoUploadEvent>((event, emit) async {
      emit(UploadLoadingState());
      try {
        await UploadRepository().uploadVideo();

        emit(UploadSuccessState());
      } catch (e) {
        emit(UploadErrorState());
      }
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository _roomRepository;

  RoomBloc({required RoomRepository roomRepository})
      : _roomRepository = roomRepository,
        super(RoomInitial()) {
    on<RoomEvent>((event, emit) async {
      if (event is OpenMicrophone) {
        await _openMicrophone(event, emit);
      } else if (event is OpenCamera) {
        await _openCamera(event, emit);
      }
    }, transformer: (events, mapper) => events.asyncExpand(mapper));
  }
  Future<void> _openCamera(OpenCamera event, emit) async {
    emit(OpenCameraInProcess());
    try {
      await _roomRepository.openUserMedia(
          localVideo: event.localVideo,
          remoteVideo: event.remoteVideo,
          openMic: event.openMic,
          openCamera: event.openCamera);
      emit(OpenCameraSuccess());
    } catch (e) {
      emit(RoomFailure(error: e));
    }
  }

  Future<void> _openMicrophone(OpenMicrophone event, emit) async {
    emit(OpenInMicrophoneProcess());
    try {
      await _roomRepository.openUserMedia(
          localVideo: event.localVideo,
          remoteVideo: event.remoteVideo,
          openMic: event.openMic,
          openCamera: event.openCamera);
      emit(OpenMicrophoneSuccess());
    } catch (e) {
      emit(RoomFailure(error: e));
    }
  }
}

part of 'room_bloc.dart';

sealed class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class OpenMicrophone extends RoomEvent {
  final RTCVideoRenderer localVideo;
  final RTCVideoRenderer remoteVideo;
  final bool openMic;
  final bool openCamera;

  const OpenMicrophone(
      {required this.localVideo,
      required this.remoteVideo,
      required this.openMic,
      required this.openCamera});

  @override
  List<Object> get props =>
      super.props..addAll([localVideo, remoteVideo, openMic, openCamera]);
}

class OpenCamera extends RoomEvent {
  final RTCVideoRenderer localVideo;
  final RTCVideoRenderer remoteVideo;
  final bool openMic;
  final bool openCamera;

  const OpenCamera(
      {required this.localVideo,
      required this.remoteVideo,
      required this.openMic,
      required this.openCamera});
  @override
  List<Object> get props =>
      super.props..addAll([localVideo, remoteVideo, openMic, openCamera]);
}

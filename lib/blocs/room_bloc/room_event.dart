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
  final bool isFrontCameraSelected;

  const OpenMicrophone(
      {required this.localVideo,
      required this.remoteVideo,
      required this.openMic,
      required this.openCamera,
      required this.isFrontCameraSelected});

  @override
  List<Object> get props => super.props
    ..addAll(
        [localVideo, remoteVideo, openMic, openCamera, isFrontCameraSelected]);
}

class SwitchCamera extends RoomEvent {
  final RTCVideoRenderer localVideo;
  final RTCVideoRenderer remoteVideo;
  final bool openMic;
  final bool openCamera;
  final bool isFrontCameraSelected;

  const SwitchCamera(
      {required this.localVideo,
      required this.remoteVideo,
      required this.openMic,
      required this.openCamera,
      required this.isFrontCameraSelected});

  @override
  List<Object> get props => super.props
    ..addAll(
        [localVideo, remoteVideo, openMic, openCamera, isFrontCameraSelected]);
}

class TakeStream extends RoomEvent {
  final RTCVideoRenderer remoteRenderer;

  const TakeStream({required this.remoteRenderer});

  @override
  List<Object> get props => super.props..addAll([remoteRenderer]);
}

class OpenCamera extends RoomEvent {
  final RTCVideoRenderer localVideo;
  final RTCVideoRenderer remoteVideo;
  final bool openMic;
  final bool openCamera;
  final bool isFrontCameraSelected;

  const OpenCamera(
      {required this.localVideo,
      required this.remoteVideo,
      required this.openMic,
      required this.openCamera,
      required this.isFrontCameraSelected});
  @override
  List<Object> get props => super.props
    ..addAll(
        [localVideo, remoteVideo, openMic, openCamera, isFrontCameraSelected]);
}

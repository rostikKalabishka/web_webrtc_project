import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';

abstract interface class RoomRepositoryInterface {
  Future<void> createRoom(RoomModel roomModel);

  Future<List<RoomModel>> getAllRooms();

  Future<List<LanguagesModel>> getAllLanguage();

  Future<List<RoomModel>> searchRooms(String query);

  Future<void> joinRoom(RoomModel roomModel, RTCVideoRenderer remoteVideo);

  Future<void> openUserMedia(
      {required RTCVideoRenderer localVideo,
      required RTCVideoRenderer remoteVideo,
      required bool openMic,
      required bool openCamera,
      required bool isFrontCameraSelected});
}

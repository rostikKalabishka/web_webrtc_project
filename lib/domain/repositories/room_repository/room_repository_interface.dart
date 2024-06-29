import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';

abstract interface class RoomRepositoryInterface {
  Future<void> createRoom(RoomModel roomModel);

  Future<List<RoomModel>> getAllRooms();

  Future<void> joinToRoom(RoomModel roomModel);

  Future<List<LanguagesModel>> getAllLanguage();
}

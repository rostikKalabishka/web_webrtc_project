import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository_interface.dart';

class RoomRepository implements RoomRepositoryInterface {
  final roomsCollection = FirebaseFirestore.instance.collection('rooms');

  final languagesCollection =
      FirebaseFirestore.instance.collection('languages');

  @override
  Future<void> createRoom(RoomModel roomModel) async {
    roomModel = roomModel.copyWith(
      createTimeRoom: DateTime.now(),
      id: const Uuid().v1(),
    );

    try {
      final roomModelJson = roomModel.toJson();
      await roomsCollection.doc(roomModel.id).set(roomModelJson);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<RoomModel>> getAllRooms() async {
    try {
      return roomsCollection.get().then((value) =>
          value.docs.map((e) => RoomModel.fromJson(e.data())).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> joinToRoom(RoomModel roomModel) async {
    try {} catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<LanguagesModel>> getAllLanguage() async {
    try {
      return languagesCollection.get().then((value) =>
          value.docs.map((e) => LanguagesModel.fromJson(e.data())).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

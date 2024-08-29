import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';

class RoomRepository {
  static const String _roomsCollection = 'rooms';
  static const String _candidatesCollection = 'candidates';
  static const String _candidateUidField = 'uid';

  final roomsCollection =
      FirebaseFirestore.instance.collection(_roomsCollection);

  final languagesCollection =
      FirebaseFirestore.instance.collection('languages');

  Future<RoomModel> createRoom(
      {required RTCSessionDescription offer,
      required RoomModel roomModel}) async {
    final roomRef = roomsCollection.doc(roomModel.id);

    Map<String, dynamic> roomWithOffer = {
      'offer': offer.toMap(),
    }..addAll(
        roomModel.toJson(),
      );

    await roomRef.set(roomWithOffer);

    return roomModel;
  }

  Future<void> deleteRoom({required String roomId}) =>
      roomsCollection.doc(roomId).delete();

  Future<void> setAnswer({
    required String roomId,
    required RTCSessionDescription answer,
  }) async {
    final roomRef = roomsCollection.doc(roomId);
    final roomWithAnswer = <String, dynamic>{
      'answer': {'type': answer.type, 'sdp': answer.sdp}
    };
    await roomRef.update(roomWithAnswer);
  }

  Future<RTCSessionDescription?> getRoomOfferIfExists(
      {required String roomId}) async {
    final roomDoc = await roomsCollection.doc(roomId).get();
    if (!roomDoc.exists) {
      return null;
    } else {
      final data = roomDoc.data() as Map<String, dynamic>;
      final offer = data['offer'];
      return RTCSessionDescription(offer['sdp'], offer['type']);
    }
  }

  Stream<RTCSessionDescription?> getRoomDataStream({required String roomId}) {
    final snapshots = roomsCollection.doc(roomId).snapshots();
    final filteredStream = snapshots.map((snapshot) => snapshot.data());
    return filteredStream.map(
      (data) {
        if (data != null && data['answer'] != null) {
          return RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );
        } else {
          return null;
        }
      },
    );
  }

  Stream<List<RTCIceCandidate>> getCandidatesAddedToRoomStream({
    required String roomId,
    required bool listenCaller,
    required String userId,
  }) {
    final snapshots = roomsCollection
        .doc(roomId)
        .collection(_candidatesCollection)
        .where(_candidateUidField, isNotEqualTo: userId)
        .snapshots();

    final convertedStream = snapshots.map(
      (snapshot) {
        final docChangesList = listenCaller
            ? snapshot.docChanges
            : snapshot.docChanges
                .where((change) => change.type == DocumentChangeType.added);
        return docChangesList.map((change) {
          final data = change.doc.data() as Map<String, dynamic>;
          return RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex'],
          );
        }).toList();
      },
    );

    return convertedStream;
  }

  Future<void> addCandidateToRoom({
    required String roomId,
    required RTCIceCandidate candidate,
    required String userId,
  }) async {
    try {
      final roomRef = roomsCollection.doc(roomId);
      final candidatesCollection = roomRef.collection(_candidatesCollection);
      await candidatesCollection
          .add(candidate.toMap()..[_candidateUidField] = userId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<RoomModel>> searchRooms(String query) async {
    try {
      var snapshot = await roomsCollection.get();

      var filteredDocs = snapshot.docs
          .where((doc) => doc.data()['roomName'].toString().contains(query));

      return filteredDocs.map((doc) => RoomModel.fromJson(doc.data())).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<RoomModel>> getAllRooms() async {
    try {
      return roomsCollection.get().then((value) =>
          value.docs.map((e) => RoomModel.fromJson(e.data())).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

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

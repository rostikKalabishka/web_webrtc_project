// import 'dart:convert';
// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:uuid/uuid.dart';
// import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';
// import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';
// import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository_interface.dart';

// import '../user_repository/models/my_user_model.dart';

// class RoomRepository implements RoomRepositoryInterface {
//   Map<String, dynamic> configuration = {
//     'iceServers': [
//       {
//         'urls': [
//           'stun:stun1.l.google.com:19302',
//           'stun:stun2.l.google.com:19302'
//         ]
//       }
//     ]
//   };

//   RTCPeerConnection? peerConnection;
//   MediaStream? localStream;
//   MediaStream? remoteStream;

//   final roomsCollection = FirebaseFirestore.instance.collection('rooms');

//   final languagesCollection =
//       FirebaseFirestore.instance.collection('languages');

//   @override
//   Future<void> createRoom(
//       RoomModel roomModel, RTCVideoRenderer remoteVideo) async {
//     roomModel = roomModel.copyWith(
//       createTimeRoom: DateTime.now(),
//       id: const Uuid().v1(),
//     );
//     DocumentReference roomRef = roomsCollection.doc(roomModel.id);

//     try {
//       log('Create PeerConnection with configuration: $configuration');

//       peerConnection = await createPeerConnection(configuration);

//       registerPeerConnectionListeners();

//       localStream?.getTracks().forEach((track) {
//         peerConnection?.addTrack(track, localStream!);
//       });

//       // Code for collecting ICE candidates below

//       var callerCandidatesCollection = roomRef.collection('callerCandidates');

//       peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
//         log('Got candidate: ${candidate.toMap()}');
//         callerCandidatesCollection.add(candidate.toMap());
//       };
//       // Finish Code for collecting ICE candidate

//       // Add code for creating a room
//       RTCSessionDescription offer = await peerConnection!.createOffer();
//       await peerConnection!.setLocalDescription(offer);
//       print('Created offer: $offer');

//       Map<String, dynamic> roomWithOffer = {
//         'offer': offer.toMap(),
//       }..addAll(
//           roomModel.toJson(),
//         );
//       await roomRef.set(roomWithOffer);

//       peerConnection?.onTrack = (RTCTrackEvent event) {
//         log('Got remote track: ${event.streams[0]}');

//         event.streams[0].getTracks().forEach((track) {
//           log('Add a track to the remoteStream $track');
//           remoteStream?.addTrack(track);
//         });
//       };

//       roomRef.snapshots().listen((snapshot) async {
//         log('Got updated room: ${snapshot.data()}');

//         Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//         if (peerConnection?.getRemoteDescription() != null &&
//             data['answer'] != null) {
//           var answer = RTCSessionDescription(
//             data['answer']['sdp'],
//             data['answer']['type'],
//           );

//           log("Someone tried to connect");
//           await peerConnection?.setRemoteDescription(answer);
//         }
//       });
//       // Listening for remote session description above

//       // Listen for remote Ice candidates below
//       roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
//         snapshot.docChanges.forEach((change) {
//           if (change.type == DocumentChangeType.added) {
//             Map<String, dynamic> data =
//                 change.doc.data() as Map<String, dynamic>;
//             log('Got new remote ICE candidate: ${jsonEncode(data)}');
//             peerConnection!.addCandidate(
//               RTCIceCandidate(
//                 data['candidate'],
//                 data['sdpMid'],
//                 data['sdpMLineIndex'],
//               ),
//             );
//           }
//         });
//       });
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<List<RoomModel>> getAllRooms() async {
//     try {
//       return roomsCollection.get().then((value) =>
//           value.docs.map((e) => RoomModel.fromJson(e.data())).toList());
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<void> joinRoom(RoomModel roomModel, RTCVideoRenderer remoteVideo,
//       MyUserModel calleeUser) async {
//     DocumentReference roomRef = roomsCollection.doc(roomModel.id);
//     var roomSnapshot = await roomRef.get();
//     log('Got room ${roomSnapshot.exists}');
//     if (roomSnapshot.exists) {
//       log('Create PeerConnection with configuration: $configuration');
//       peerConnection = await createPeerConnection(configuration);

//       registerPeerConnectionListeners();

//       localStream?.getTracks().forEach((track) {
//         peerConnection?.addTrack(track, localStream!);
//       });

//       // Code for collecting ICE candidates below
//       var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
//       peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
//         if (candidate == null) {
//           log('onIceCandidate: complete!');
//           return;
//         }
//         log('onIceCandidate: ${candidate.toMap()}');
//         calleeCandidatesCollection.add(candidate.toMap());
//       };
//       // Code for collecting ICE candidate above

//       peerConnection?.onTrack = (RTCTrackEvent event) {
//         log('Got remote track: ${event.streams[0]}');
//         event.streams[0].getTracks().forEach((track) {
//           log('Add a track to the remoteStream: $track');
//           remoteStream?.addTrack(track);
//         });
//       };

//       var data = roomSnapshot.data() as Map<String, dynamic>;
//       log('Got offer $data');
//       var offer = data['offer'];
//       await peerConnection?.setRemoteDescription(
//         RTCSessionDescription(offer['sdp'], offer['type']),
//       );
//       var answer = await peerConnection!.createAnswer();
//       log('Created Answer $answer');

//       await peerConnection!.setLocalDescription(answer);

//       Map<String, dynamic> roomWithAnswer = {
//         'answer': {'type': answer.type, 'sdp': answer.sdp}
//       };

//       await roomRef.update(roomWithAnswer);

//       // Finished creating SDP answer

//       // Listening for remote ICE candidates below
//       roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
//         snapshot.docChanges.forEach((document) {
//           var data = document.doc.data() as Map<String, dynamic>;
//           log(data.toString());
//           log('Got new remote ICE candidate: $data');
//           peerConnection!.addCandidate(
//             RTCIceCandidate(
//               data['candidate'],
//               data['sdpMid'],
//               data['sdpMLineIndex'],
//             ),
//           );
//         });
//       });
//     }
//   }

//   @override
//   Future<List<LanguagesModel>> getAllLanguage() async {
//     try {
//       return languagesCollection.get().then((value) =>
//           value.docs.map((e) => LanguagesModel.fromJson(e.data())).toList());
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<List<RoomModel>> searchRooms(String query) async {
//     try {
//       var snapshot = await roomsCollection.get();

//       var filteredDocs = snapshot.docs
//           .where((doc) => doc.data()['roomName'].toString().contains(query));

//       return filteredDocs.map((doc) => RoomModel.fromJson(doc.data())).toList();
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<void> openUserMedia(
//       {required RTCVideoRenderer localVideo,
//       required RTCVideoRenderer remoteVideo,
//       required bool openMic,
//       required bool openCamera,
//       required bool isFrontCameraSelected}) async {
//     try {
//       var stream = await navigator.mediaDevices.getUserMedia({
//         'video': openCamera,
//         'audio': openMic
//             ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
//             : false,
//       });

//       localVideo.srcObject = stream;
//       localStream = stream;

//       // Add the stream to peerConnection
//       stream.getTracks().forEach((track) {
//         peerConnection?.addTrack(track, stream);
//       });

//       remoteVideo.srcObject = await createLocalMediaStream('key');
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   void registerPeerConnectionListeners() {
//     peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
//       log('ICE gathering state changed: $state');
//     };

//     peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
//       log('Connection state change: $state');
//     };

//     peerConnection?.onSignalingState = (RTCSignalingState state) {
//       log('Signaling state change: $state');
//     };

//     peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
//       log('ICE connection state change: $state');
//     };
//   }
// }

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:uuid/uuid.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';

class RoomRepository {
  static const String _roomsCollection = 'rooms';
  static const String _candidatesCollection = 'candidates';
  static const String _candidateUidField = 'uid';

  final roomsCollection =
      FirebaseFirestore.instance.collection(_roomsCollection);

  final languagesCollection =
      FirebaseFirestore.instance.collection('languages');

  String? userId;

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
  }) async {
    final roomRef = roomsCollection.doc(roomId);
    final candidatesCollection = roomRef.collection(_candidatesCollection);
    await candidatesCollection
        .add(candidate.toMap()..[_candidateUidField] = userId);
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

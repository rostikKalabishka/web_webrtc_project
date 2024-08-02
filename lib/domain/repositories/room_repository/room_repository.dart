import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository_interface.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';

typedef void StreamStateCallback(MediaStream stream);

class RoomRepository implements RoomRepositoryInterface {
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;

  StreamStateCallback? onAddRemoteStream;

  final roomsCollection = FirebaseFirestore.instance.collection('rooms');
  final languagesCollection =
      FirebaseFirestore.instance.collection('languages');

  // void _initializeRemoteStream() async {
  //   remoteStream ??= await createLocalMediaStream('key');
  // }

  void _addTracksToRemoteStream(RTCTrackEvent event) {
    event.streams[0].getTracks().forEach((track) {
      log('Add a track to the remoteStream: ${track.id}');
      remoteStream?.addTrack(track);
    });
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      log('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      log('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      log('Signaling state change: $state');
    };

    peerConnection?.onTrack = (RTCTrackEvent event) async {
      log('Got remote track: ${event.streams[0]}');
      // _initializeRemoteStream();
      _addTracksToRemoteStream(event);
      onAddRemoteStream?.call(remoteStream!);
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print('Add remote stream');
      onAddRemoteStream?.call(remoteStream!);
      remoteStream = stream;
    };
  }

  @override
  Future<void> createRoom(
      RoomModel roomModel, RTCVideoRenderer remoteRender) async {
    DocumentReference roomRef = roomsCollection.doc(roomModel.id);

    try {
      log('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);
      if (peerConnection == null) {
        throw 'Failed to create PeerConnection';
      }

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        log('Adding track to peer connection: ${track.id}');
        peerConnection?.addTrack(track, localStream!);
      });

      var callerCandidatesCollection = roomRef.collection('callerCandidates');
      peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        log('Got candidate: ${candidate.toMap()}');
        callerCandidatesCollection.add(candidate.toMap());
      };

      RTCSessionDescription offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);

      Map<String, dynamic> roomWithOffer = {
        'offer': offer.toMap(),
      }..addAll(roomModel.toJson());
      await roomRef.set(roomWithOffer);

      roomRef.snapshots().listen((snapshot) async {
        log('Got updated room: ${snapshot.data()}');
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (peerConnection?.signalingState ==
                RTCSignalingState.RTCSignalingStateStable &&
            peerConnection?.getRemoteDescription() == null &&
            data?['answer'] != null) {
          var answer = RTCSessionDescription(
            data!['answer']['sdp'],
            data['answer']['type'],
          );

          log("Someone tried to connect");
          await peerConnection?.setRemoteDescription(answer);
        }
      });

      roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            Map<String, dynamic> data =
                change.doc.data() as Map<String, dynamic>;
            log('Got new remote ICE candidate: ${jsonEncode(data)}');
            peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        });
      });
    } catch (e) {
      log('Error creating room: $e');
      rethrow;
    }
  }

  @override
  Future<List<RoomModel>> getAllRooms() async {
    try {
      return roomsCollection.get().then((value) =>
          value.docs.map((e) => RoomModel.fromJson(e.data())).toList());
    } catch (e) {
      log('Error getting all rooms: $e');
      rethrow;
    }
  }

  @override
  Future<void> joinRoom(RoomModel roomModel, RTCVideoRenderer remoteVideo,
      MyUserModel calleeUser) async {
    DocumentReference roomRef = roomsCollection.doc(roomModel.id);
    var roomSnapshot = await roomRef.get();
    log('Got room ${roomSnapshot.exists}');
    if (roomSnapshot.exists) {
      try {
        log('Create PeerConnection with configuration: $configuration');
        peerConnection = await createPeerConnection(configuration);
        if (peerConnection == null) {
          throw 'Failed to create PeerConnection';
        }

        registerPeerConnectionListeners();

        localStream?.getTracks().forEach((track) {
          log('Adding track to peer connection: ${track.id}');
          peerConnection?.addTrack(track, localStream!);
        });

        var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
        peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
          if (candidate == null) {
            log('onIceCandidate: complete!');
            return;
          }
          log('onIceCandidate: ${candidate.toMap()}');
          calleeCandidatesCollection.add(candidate.toMap());
        };

        var data = roomSnapshot.data() as Map<String, dynamic>;
        log('Got offer $data');
        var offer = data['offer'];
        await peerConnection?.setRemoteDescription(
          RTCSessionDescription(offer['sdp'], offer['type']),
        );
        var answer = await peerConnection!.createAnswer();
        log('Created Answer $answer');

        await peerConnection!.setLocalDescription(answer);

        Map<String, dynamic> roomWithAnswer = {
          'answer': {'type': answer.type, 'sdp': answer.sdp},
          'calleeUser': calleeUser.toJson()
        };

        await roomRef.update(roomWithAnswer);

        roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
          snapshot.docChanges.forEach((document) {
            var data = document.doc.data() as Map<String, dynamic>;
            log(data.toString());
            log('Got new remote ICE candidate: $data');
            peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          });
        });
      } catch (e) {
        log('Error joining room: $e');
        rethrow;
      }
    }
  }

  @override
  Future<List<LanguagesModel>> getAllLanguage() async {
    try {
      return languagesCollection.get().then((value) =>
          value.docs.map((e) => LanguagesModel.fromJson(e.data())).toList());
    } catch (e) {
      log('Error getting all languages: $e');
      rethrow;
    }
  }

  @override
  Future<List<RoomModel>> searchRooms(String query) async {
    try {
      var snapshot = await roomsCollection.get();
      var filteredDocs = snapshot.docs
          .where((doc) => doc.data()['roomName'].toString().contains(query));
      return filteredDocs.map((doc) => RoomModel.fromJson(doc.data())).toList();
    } catch (e) {
      log('Error searching rooms: $e');
      rethrow;
    }
  }

  @override
  Future<void> openUserMedia({
    required RTCVideoRenderer localVideo,
    required RTCVideoRenderer remoteVideo,
    required bool openMic,
    required bool openCamera,
    required bool isFrontCameraSelected,
  }) async {
    try {
      var stream = await navigator.mediaDevices.getUserMedia({
        'video': openCamera,
        'audio': openMic
            ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
            : false,
      });

      localVideo.srcObject = stream;
      localStream = stream;

      stream.getTracks().forEach((track) {
        log('Adding track to peer connection: ${track.id}');
        peerConnection?.addTrack(track, stream);
      });

      remoteVideo.srcObject = await createLocalMediaStream('key');
    } catch (e) {
      log('Error opening user media: $e');
      rethrow;
    }
  }
}

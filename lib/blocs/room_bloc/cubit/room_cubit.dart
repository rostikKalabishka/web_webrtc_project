import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:webrtc_flutter/blocs/room_bloc/cubit/room_state.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/models.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';

class RoomBloc extends Cubit<RoomState> {
  final RoomRepository _roomRepository;
  final List<StreamSubscription> _subscriptions = [];
  MyUserModel? myUserModel;

  static const Map<String, dynamic> _configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  RoomBloc({required RoomRepository roomRepository})
      : _roomRepository = roomRepository,
        super(const RoomState());

  Future<void> createRoom({
    required RoomModel room,
  }) async {
    try {
      await _createPeerConnection();

      final offer = await state.peerConnection!.createOffer();
      final roomModel =
          await _roomRepository.createRoom(offer: offer, roomModel: room);

      if (state.peerConnection != null) {
        print("Registering peer connection listeners");
        _registerPeerConnectionListeners(roomModel);
      } else {
        print("PeerConnection is null after creation");
      }

      state.localStream?.getTracks().forEach((track) {
        state.peerConnection!.addTrack(track, state.localStream!);
      });
      emit(state.copyWith(
        roomModel: roomModel,
      ));

      await state.peerConnection!.setLocalDescription(offer);
      _subscriptions.addAll([
        _roomRepository
            .getRoomDataStream(roomId: roomModel.id)
            .listen((answer) async {
          if (answer != null) {
            await state.peerConnection?.setRemoteDescription(answer);
          } else {
            if (state.remoteStream != null) {
              emit(state.copyWith(clearAll: true));
            }
          }
        }),
        _roomRepository
            .getCandidatesAddedToRoomStream(
                roomId: roomModel.id,
                listenCaller: false,
                userId: myUserModel!.id)
            .listen((candidates) {
          for (final candidate in candidates) {
            state.peerConnection?.addCandidate(candidate);
          }
        }),
      ]);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> joinRoom({
    required RoomModel room,
  }) async {
    try {
      final sessionDescription =
          await _roomRepository.getRoomOfferIfExists(roomId: room.id);

      if (sessionDescription != null) {
        _registerPeerConnectionListeners(room);

        state.localStream?.getTracks().forEach((track) {
          state.peerConnection!.addTrack(track, state.localStream!);
        });

        await state.peerConnection!.setRemoteDescription(sessionDescription);
        final answer = await state.peerConnection!.createAnswer();

        await state.peerConnection!.setLocalDescription(answer);
        await _roomRepository.setAnswer(roomId: room.id, answer: answer);
        _subscriptions.addAll([
          _roomRepository
              .getCandidatesAddedToRoomStream(
                  roomId: room.id, listenCaller: true, userId: myUserModel!.id)
              .listen((candidates) {
            for (final candidate in candidates) {
              state.peerConnection?.addCandidate(candidate);
            }
          }),
          _roomRepository
              .getRoomDataStream(roomId: room.id)
              .listen((answer) async {
            if (answer == null) {
              emit(state.copyWith(clearAll: true));
            }
          })
        ]);
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> enableUserMediaStream() async {
    try {
      var stream = await navigator.mediaDevices
          .getUserMedia({'video': true, 'audio': true});
      emit(
        state.copyWith(
            localStream: stream, currentUserShown: true, clearAll: true),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void enableVideo() {
    try {
      if (state.videoDisabled) {
        state.localStream
            ?.getVideoTracks()
            .forEach((track) => track.enabled = true);
        emit(state.copyWith(videoDisabled: false));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void disableVideo() {
    try {
      if (!state.videoDisabled) {
        state.localStream
            ?.getVideoTracks()
            .forEach((track) => track.enabled = false);
        emit(state.copyWith(videoDisabled: true));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void enableAudio() {
    try {
      if (state.audioDisabled) {
        state.localStream
            ?.getAudioTracks()
            .forEach((track) => track.enabled = true);
        emit(state.copyWith(audioDisabled: false));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void disableAudio() {
    try {
      if (!state.audioDisabled) {
        state.localStream
            ?.getAudioTracks()
            .forEach((track) => track.enabled = false);
        emit(state.copyWith(audioDisabled: true));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> hangUp(RTCVideoRenderer localVideo) async {
    try {
      final tracks = localVideo.srcObject!.getTracks();
      for (var track in tracks) {
        track.stop();
      }

      if (state.remoteStream != null) {
        state.remoteStream!.getTracks().forEach((track) => track.stop());
      }
      if (state.peerConnection != null) state.peerConnection!.close();

      if (state.roomModel != null) {
        _roomRepository.deleteRoom(roomId: state.roomModel!.id);
      }

      state.localStream!.dispose();
      state.remoteStream?.dispose();

      for (final subs in _subscriptions) {
        subs.cancel();
      }
      _subscriptions.clear();

      emit(state.copyWith(clearAll: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _createPeerConnection() async {
    try {
      final peerConnection = await createPeerConnection(_configuration);
      print("PeerConnection created successfully");
      emit(state.copyWith(peerConnection: peerConnection));
    } catch (e) {
      print("Error creating PeerConnection: $e");
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _registerPeerConnectionListeners(RoomModel roomModel) {
    final peerConnection = state.peerConnection;
    if (peerConnection == null) {
      print("PeerConnection is null in _registerPeerConnectionListeners");
      return;
    }

    try {
      peerConnection.onIceCandidate = (candidate) async {
        print("onIceCandidate triggered with candidate: ${candidate.toMap()}");
        try {
          await _roomRepository.addCandidateToRoom(
            roomId: roomModel.id,
            candidate: candidate,
            userId: myUserModel!.id,
          );
          print("Candidate added successfully");
        } catch (e) {
          print("Error adding candidate: $e");
          emit(state.copyWith(error: e.toString()));
        }
      };

      peerConnection.onAddStream = (MediaStream stream) {
        print("onAddStream triggered with stream: ${stream.id}");
        emit(state.copyWith(remoteStream: stream, companionShown: true));
      };

      peerConnection.onTrack = (event) {
        print("onTrack triggered with event: ${event}");
        if (event.streams.isNotEmpty) {
          final stream = event.streams.first;
          print("onTrack triggered with stream: ${stream.id}");
          emit(state.copyWith(remoteStream: stream, companionShown: true));
        } else {
          print("No streams found in onTrack event");
        }
      };

      // Проверка слушателей
      log('onIceCandidate: ${peerConnection.onIceCandidate}');
      log('onAddStream: ${peerConnection.onAddStream}');
      log('onTrack: ${peerConnection.onTrack}');
    } catch (e) {
      print("Error in _registerPeerConnectionListeners: $e");
      emit(state.copyWith(error: e.toString()));
    }
  }
}

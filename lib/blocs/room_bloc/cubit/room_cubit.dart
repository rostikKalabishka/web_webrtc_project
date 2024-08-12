import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:webrtc_flutter/blocs/room_bloc/cubit/room_state.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/models.dart';

import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository.dart';

class RoomBloc extends Cubit<RoomState> {
  final RoomRepository _roomRepository;

  final List<StreamSubscription> _subscriptions = [];

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
    //required LanguagesModel roomLanguage,
  }) async {
    try {
      await _createPeerConnection();

      final offer = await state.peerConnection!.createOffer();
      final roomModel =
          await _roomRepository.createRoom(offer: offer, roomModel: room);

      _registerPeerConnectionListeners(roomModel);

      state.localStream?.getTracks().forEach((track) {
        state.peerConnection!.addTrack(track, state.localStream!);
      });
      emit(state.copyWith(roomModel: roomModel));

      await state.peerConnection!.setLocalDescription(offer);
      _subscriptions.addAll([
        _roomRepository
            .getRoomDataStream(roomId: roomModel.id)
            .listen((answer) async {
          if (answer != null) {
            state.peerConnection?.setRemoteDescription(answer);
          } else {
            if (state.remoteStream != null) {
              emit(state.copyWith(clearAll: true));
            }
          }
        }),
        _roomRepository
            .getCandidatesAddedToRoomStream(
                roomId: roomModel.id, listenCaller: false)
            .listen(
          (candidates) {
            for (final candidate in candidates) {
              state.peerConnection?.addCandidate(candidate);
            }
          },
        ),
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

        state.peerConnection!.setRemoteDescription(sessionDescription);
        final answer = await state.peerConnection!.createAnswer();

        await state.peerConnection!.setLocalDescription(answer);
        await _roomRepository.setAnswer(roomId: room.id, answer: answer);
        _subscriptions.addAll([
          _roomRepository
              .getCandidatesAddedToRoomStream(
                  roomId: room.id, listenCaller: true)
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

      emit(state.copyWith(peerConnection: peerConnection));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _registerPeerConnectionListeners(RoomModel roomModel) {
    try {
      state.peerConnection!.onIceCandidate = (candidate) {
        _roomRepository.addCandidateToRoom(
            roomId: roomModel.id, candidate: candidate);
      };

      state.peerConnection!.onAddStream = (stream) {
        emit(state.copyWith(remoteStream: stream, companionShown: true));
      };
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';

class RoomState extends Equatable {
  final RoomModel? roomModel;
  final MediaStream? localStream;
  final MediaStream? remoteStream;
  final RTCPeerConnection? peerConnection;

  final bool currentUserShown;
  final bool companionShown;
  final bool videoDisabled;
  final bool audioDisabled;
  final bool microMuted;
  final Object error;

  const RoomState(
      {this.roomModel,
      this.error = '',
      this.localStream,
      this.remoteStream,
      this.peerConnection,
      this.currentUserShown = false,
      this.companionShown = false,
      this.videoDisabled = false,
      this.audioDisabled = false,
      this.microMuted = false});
  @override
  List<Object?> get props => [
        roomModel,
        localStream,
        remoteStream,
        peerConnection,
        currentUserShown,
        companionShown,
        videoDisabled,
        audioDisabled,
        microMuted,
        error,
      ];

  RoomState copyWith({
    RoomModel? roomModel,
    MediaStream? localStream,
    MediaStream? remoteStream,
    RTCPeerConnection? peerConnection,
    bool? cleared,
    bool? currentUserShown,
    bool? companionShown,
    bool? videoDisabled,
    bool? audioDisabled,
    bool? microMuted,
    Object? error,
    bool clearRoomId = false,
    bool clearLocalStream = false,
    bool clearRemoteStream = false,
    bool clearPeerConnection = false,
  }) {
    return RoomState(
        roomModel: roomModel ?? this.roomModel,
        localStream: localStream ?? this.localStream,
        remoteStream: remoteStream ?? this.remoteStream,
        peerConnection: peerConnection ?? this.peerConnection,
        currentUserShown: currentUserShown ?? this.currentUserShown,
        companionShown: companionShown ?? this.companionShown,
        videoDisabled: videoDisabled ?? this.videoDisabled,
        audioDisabled: audioDisabled ?? this.audioDisabled,
        microMuted: microMuted ?? this.microMuted,
        error: error ?? this.error);
  }
}

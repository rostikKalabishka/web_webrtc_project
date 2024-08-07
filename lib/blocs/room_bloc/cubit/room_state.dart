import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';

class RoomState extends Equatable {
  final RoomModel? roomModel;
  final MediaStream? localStream;
  final MediaStream? remoteStream;
  final RTCPeerConnection? peerConnection;
  final bool cleared;
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
      this.cleared = false,
      this.currentUserShown = false,
      this.companionShown = false,
      this.videoDisabled = false,
      this.audioDisabled = false,
      this.microMuted = false});
  @override
  List<Object> get props => [];

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
    bool clearAll = false,
  }) {
    return RoomState(
        cleared: clearAll,
        roomModel: clearAll || clearRoomId ? null : roomModel ?? this.roomModel,
        localStream: clearAll || clearLocalStream
            ? null
            : localStream ?? this.localStream,
        remoteStream: clearAll || clearRemoteStream
            ? null
            : remoteStream ?? this.remoteStream,
        peerConnection: clearAll || clearPeerConnection
            ? null
            : peerConnection ?? this.peerConnection,
        currentUserShown:
            clearAll ? false : (currentUserShown ?? this.currentUserShown),
        companionShown:
            clearAll ? false : (companionShown ?? this.companionShown),
        videoDisabled: clearAll ? false : (videoDisabled ?? this.videoDisabled),
        audioDisabled: clearAll ? false : (audioDisabled ?? this.audioDisabled),
        microMuted: clearAll ? false : (microMuted ?? this.microMuted));
  }
}

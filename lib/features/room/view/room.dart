import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc_flutter/blocs/room_bloc/cubit/room_cubit.dart';
import 'package:webrtc_flutter/blocs/room_bloc/cubit/room_state.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';

@RoutePage()
class RoomScreen extends StatefulWidget {
  const RoomScreen(
      {super.key, required this.roomModel, required this.remoteRenderer});

  final RoomModel roomModel;
  final RTCVideoRenderer remoteRenderer;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  static const double _defaultPadding = 20;

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    _localRenderer.initialize().then((_) {
      final roomState = context.read<RoomBloc>().state;
      if (roomState.localStream != null) {
        _localRenderer.srcObject = roomState.localStream!;
      }
    });

    _remoteRenderer.initialize().then((_) {
      final roomState = context.read<RoomBloc>().state;
      if (roomState.remoteStream != null) {
        _remoteRenderer.srcObject = roomState.remoteStream!;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoomBloc, RoomState>(
      listenWhen: (prev, next) =>
          prev.localStream != next.localStream ||
          prev.remoteStream != next.remoteStream ||
          prev.roomModel != next.roomModel ||
          next.cleared,
      listener: (context, state) {
        if (state.localStream != null &&
            _localRenderer.srcObject != state.localStream) {
          _localRenderer.srcObject = state.localStream!;
        }
        if (state.remoteStream != null &&
            _remoteRenderer.srcObject != state.remoteStream) {
          _remoteRenderer.srcObject = state.remoteStream!;
        }
        setState(() {});
      },
      builder: (context, state) {
        return Scaffold(
          body: _getContent(state),
        );
      },
    );
  }

  Widget _getContent(RoomState state) {
    if (state.currentUserShown && state.companionShown) {
      return _fullConversation(
        cameraEnabled: !state.videoDisabled,
        microEnabled: !state.audioDisabled,
      );
    } else {
      return _myVideoFullScreen(
        cameraEnabled: !state.videoDisabled,
        microEnabled: !state.audioDisabled,
      );
    }
  }

  Widget _myVideoFullScreen({
    required bool cameraEnabled,
    required bool microEnabled,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: RTCVideoView(
            _localRenderer,
            mirror: true,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
        Positioned(
            bottom: _defaultPadding,
            left: 0,
            right: 0,
            child: _buttonsWidget(
                cameraEnabled: cameraEnabled, microEnabled: microEnabled)),
      ],
    );
  }

  Widget _fullConversation({
    required bool cameraEnabled,
    required bool microEnabled,
  }) {
    const previewSize = 0.3;
    final previewWidth = MediaQuery.of(context).size.width * previewSize;
    final previewHeight = (_localRenderer.videoHeight > 0 &&
            _localRenderer.videoWidth > 0)
        ? previewWidth * _localRenderer.videoHeight / _localRenderer.videoWidth
        : previewWidth * 1.33; // Стандартне співвідношення 4:3

    return Stack(
      children: [
        Positioned.fill(
          child: RTCVideoView(
            _remoteRenderer,
            mirror: false,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
        Positioned(
          right: _defaultPadding,
          bottom: _defaultPadding,
          child: Container(
            width: previewWidth,
            height: previewHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.blueAccent),
            ),
            clipBehavior: Clip.hardEdge,
            child: RTCVideoView(
              _localRenderer,
              mirror: true,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ),
        ),
        Positioned(
            bottom: _defaultPadding,
            left: 0,
            right: 0,
            child: _buttonsWidget(
                cameraEnabled: cameraEnabled, microEnabled: microEnabled)),
      ],
    );
  }

  Widget _buttonsWidget(
      {required bool microEnabled, required bool cameraEnabled}) {
    final _cubit = context.read<RoomBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(microEnabled ? Icons.mic : Icons.mic_off),
            onPressed: () {
              if (microEnabled) {
                _cubit.disableAudio();
              } else {
                _cubit.enableAudio();
              }
            },
          ),
          IconButton(
            icon: Icon(cameraEnabled ? Icons.videocam : Icons.videocam_off),
            onPressed: () {
              if (cameraEnabled) {
                _cubit.disableVideo();
              } else {
                _cubit.enableVideo();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call_end),
            iconSize: 30,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

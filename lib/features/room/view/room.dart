import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc_flutter/blocs/room_bloc/cubit/room_cubit.dart';
import 'package:webrtc_flutter/blocs/room_bloc/cubit/room_state.dart';

import 'package:webrtc_flutter/domain/repositories/room_repository/models/models.dart';
import 'package:webrtc_flutter/router/router.dart';

import '../../../domain/repositories/room_repository/room_repository.dart';

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
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool isVideoOn = false;
  bool isAudioOn = false;
  bool isFrontCameraSelected = false;
  final RoomRepository roomRepository = RoomRepository();

  @override
  void initState() {
    super.initState();

    _localRenderer.initialize();
    _remoteRenderer.initialize();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
        // bloc: roomBloc,
        builder: (context, state) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(children: [
                RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: SizedBox(
                    height: 150,
                    width: 120,
                    child: RTCVideoView(
                      _localRenderer,
                      mirror: true,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(isAudioOn ? Icons.mic : Icons.mic_off),
                    onPressed: () {
                      setState(() {
                        isAudioOn = !isAudioOn;
                      });
                      //    _toggleMicrophone();
                    },
                  ),
                  IconButton(
                    icon: Icon(isVideoOn ? Icons.videocam : Icons.videocam_off),
                    onPressed: () {
                      setState(() {
                        isVideoOn = !isVideoOn;
                      });
                      //   _toggleCamera();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cameraswitch),
                    onPressed: () {
                      //  _switchCamera();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.call_end),
                    iconSize: 30,
                    onPressed: () {
                      //       _endCall();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // void _toggleMicrophone() {
  //   roomBloc.add(OpenMicrophone(
  //       localVideo: _localRenderer,
  //       remoteVideo: _remoteRenderer,
  //       openMic: isAudioOn,
  //       openCamera: isVideoOn,
  //       isFrontCameraSelected: isFrontCameraSelected));
  // }

  // void _toggleCamera() {
  //   roomBloc.add(OpenCamera(
  //       localVideo: _localRenderer,
  //       remoteVideo: _remoteRenderer,
  //       openMic: isAudioOn,
  //       openCamera: isVideoOn,
  //       isFrontCameraSelected: isFrontCameraSelected));
  // }

  // void _switchCamera() {
  //   roomBloc.add(SwitchCamera(
  //       localVideo: _localRenderer,
  //       remoteVideo: _remoteRenderer,
  //       openMic: isAudioOn,
  //       openCamera: isVideoOn,
  //       isFrontCameraSelected: isFrontCameraSelected));
  // }

  // void _endCall() {
  //   AutoRouter.of(context)
  //       .pushAndPopUntil(const HomeRouteMobile(), predicate: (route) => false);
  // }
}

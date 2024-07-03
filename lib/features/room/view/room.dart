import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:webrtc_flutter/blocs/room_bloc/room_bloc.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/models.dart';

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
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  // RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  bool isVideoOn = true;
  bool isAudioOn = true;
  @override
  void initState() {
    _localRenderer.initialize();
    widget.remoteRenderer.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    widget.remoteRenderer.dispose();

    context.read<RoomBloc>().add(OpenCamera(
        localVideo: _localRenderer,
        remoteVideo: widget.remoteRenderer,
        openMic: isAudioOn,
        openCamera: isVideoOn));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(builder: (context, state) {
      return Scaffold(
        body: Column(
          children: [
            // Expanded(
            //   child: Stack(children: [
            //     RTCVideoView(
            //       widget.remoteRenderer,
            //       objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            //     ),
            //     Positioned(
            //       right: 20,
            //       bottom: 20,
            //       child: SizedBox(
            //         height: 150,
            //         width: 120,
            //         child: RTCVideoView(
            //           _localRenderer,
            //           mirror: true,
            //           objectFit:
            //               RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            //         ),
            //       ),
            //     )
            //   ]),
            // ),
            Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
            Expanded(child: RTCVideoView(widget.remoteRenderer)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(isAudioOn ? Icons.mic : Icons.mic_off),
                    onPressed: () {
                      isAudioOn = !isAudioOn;
                      context.read<RoomBloc>().add(OpenMicrophone(
                          localVideo: _localRenderer,
                          remoteVideo: widget.remoteRenderer,
                          openMic: isAudioOn,
                          openCamera: isVideoOn));
                    },
                  ),
                  IconButton(
                    icon: Icon(isVideoOn ? Icons.videocam : Icons.videocam_off),
                    onPressed: () {
                      isVideoOn = !isVideoOn;
                      context.read<RoomBloc>().add(OpenCamera(
                          localVideo: _localRenderer,
                          remoteVideo: widget.remoteRenderer,
                          openMic: isAudioOn,
                          openCamera: isVideoOn));
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
            ),
          ],
        ),
      );
    });
  }
}

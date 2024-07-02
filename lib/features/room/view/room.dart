import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:webrtc_flutter/blocs/room_bloc/room_bloc.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/models.dart';

@RoutePage()
class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key, required this.roomModel});
  final RoomModel roomModel;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(builder: (context, state) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(children: [
                // RTCVideoView(
                //   _remoteRTCVideoRenderer,
                //   objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                // ),
                // Positioned(
                //   right: 20,
                //   bottom: 20,
                //   child: SizedBox(
                //     height: 150,
                //     width: 120,
                //     child: RTCVideoView(
                //       _localRTCVideoRenderer,
                //       mirror: isFrontCameraSelected,
                //       objectFit:
                //           RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                //     ),
                //   ),
                // )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // IconButton(
                  //   icon: Icon(isAudioOn ? Icons.mic : Icons.mic_off),
                  //   onPressed: _toggleMic,
                  // ),
                  // IconButton(
                  //   icon: const Icon(Icons.call_end),
                  //   iconSize: 30,
                  //   onPressed: _leaveCall,
                  // ),
                  // IconButton(
                  //   icon: const Icon(Icons.cameraswitch),
                  //   onPressed: _switchCamera,
                  // ),
                  // IconButton(
                  //   icon: Icon(isVideoOn ? Icons.videocam : Icons.videocam_off),
                  //   onPressed: _toggleCamera,
                  // ),

                  IconButton(
                    icon: Icon(Icons.mic_off),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.call_end),
                    iconSize: 30,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.cameraswitch),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.videocam_off),
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

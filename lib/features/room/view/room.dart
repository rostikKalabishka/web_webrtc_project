// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:webrtc_flutter/blocs/room_bloc/cubit/room_cubit.dart';
// import 'package:webrtc_flutter/blocs/room_bloc/cubit/room_state.dart';

// import 'package:webrtc_flutter/domain/repositories/room_repository/models/models.dart';
// import 'package:webrtc_flutter/router/router.dart';

// import '../../../domain/repositories/room_repository/room_repository.dart';

// @RoutePage()
// class RoomScreen extends StatefulWidget {
//   const RoomScreen(
//       {super.key, required this.roomModel, required this.remoteRenderer});

//   final RoomModel roomModel;
//   final RTCVideoRenderer remoteRenderer;
//   @override
//   State<RoomScreen> createState() => _RoomScreenState();
// }

// class _RoomScreenState extends State<RoomScreen> {
//   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//   bool isVideoOn = false;
//   bool isAudioOn = false;
//   bool isFrontCameraSelected = false;
//   // final RoomRepository roomRepository = RoomRepository();

//   @override
//   void initState() {
//     super.initState();

//     _localRenderer.initialize();
//     _remoteRenderer.initialize();
//   }

//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RoomBloc, RoomState>(
//         // bloc: roomBloc,
//         builder: (context, state) {
//       return Scaffold(
//         body: Column(
//           children: [
//             Expanded(
//               child: Stack(children: [
//                 RTCVideoView(
//                   _remoteRenderer,
//                   objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                 ),
//                 Positioned(
//                   right: 20,
//                   bottom: 20,
//                   child: SizedBox(
//                     height: 150,
//                     width: 120,
//                     child: RTCVideoView(
//                       _localRenderer,
//                       mirror: true,
//                       objectFit:
//                           RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   IconButton(
//                     icon: Icon(isAudioOn ? Icons.mic : Icons.mic_off),
//                     onPressed: () {
//                       setState(() {
//                         isAudioOn = !isAudioOn;
//                       });
//                       //    _toggleMicrophone();
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(isVideoOn ? Icons.videocam : Icons.videocam_off),
//                     onPressed: () {
//                       setState(() {
//                         isVideoOn = !isVideoOn;
//                       });
//                       //   _toggleCamera();
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.cameraswitch),
//                     onPressed: () {
//                       //  _switchCamera();
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.call_end),
//                     iconSize: 30,
//                     onPressed: () {
//                       //       _endCall();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   // void _toggleMicrophone() {
//   //   roomBloc.add(OpenMicrophone(
//   //       localVideo: _localRenderer,
//   //       remoteVideo: _remoteRenderer,
//   //       openMic: isAudioOn,
//   //       openCamera: isVideoOn,
//   //       isFrontCameraSelected: isFrontCameraSelected));
//   // }

//   // void _toggleCamera() {
//   //   roomBloc.add(OpenCamera(
//   //       localVideo: _localRenderer,
//   //       remoteVideo: _remoteRenderer,
//   //       openMic: isAudioOn,
//   //       openCamera: isVideoOn,
//   //       isFrontCameraSelected: isFrontCameraSelected));
//   // }

//   // void _switchCamera() {
//   //   roomBloc.add(SwitchCamera(
//   //       localVideo: _localRenderer,
//   //       remoteVideo: _remoteRenderer,
//   //       openMic: isAudioOn,
//   //       openCamera: isVideoOn,
//   //       isFrontCameraSelected: isFrontCameraSelected));
//   // }

//   // void _endCall() {
//   //   AutoRouter.of(context)
//   //       .pushAndPopUntil(const HomeRouteMobile(), predicate: (route) => false);
//   // }
// }

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
  static const int roomIdLength = 20;
  static const double _defaultPadding = 20;

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

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
        if (state.cleared) {
          _localRenderer.initialize();
          _remoteRenderer.initialize();
        } else {
          if (state.localStream != null ||
              _localRenderer.srcObject != state.localStream) {
            _localRenderer.srcObject = state.localStream!;
          }
          if (state.remoteStream != null ||
              _remoteRenderer.srcObject != state.remoteStream) {
            _remoteRenderer.srcObject = state.remoteStream!;
          }
          // if (state.roomModel != null && state.roomModel != _textEditingController.text) {
          //   _textEditingController.text = state.roomId!;
          // }
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
    } else if (state.currentUserShown) {
      return _myVideoFullScreen(
        cameraEnabled: !state.videoDisabled,
        microEnabled: !state.audioDisabled,
      );
    } else {
      return _emptyPage();
    }
  }

  Widget _emptyPage() {
    final _cubit = context.read<RoomBloc>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              await _cubit.enableUserMediaStream();
              // await _cubit.createRoom();
              setState(() {});
            },
            child: const Text('Open camera and Create room'),
          ),
          const SizedBox(height: 32),
          const Text('Join the following Room: '),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.7,
          //   child: TextField(
          //     maxLength: roomIdLength,
          //     controller: _textEditingController,
          //   ),
          // ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: const ButtonStyle().copyWith(
              backgroundColor: const MaterialStatePropertyAll(Colors.grey),
            ),
            onPressed: () async {
              await _cubit.enableUserMediaStream();
              // _cubit.joinRoom(_textEditingController.text);
            },
            child: const Text('Open camera and Join room'),
          ),
        ],
      ),
    );
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
        // Positioned(
        //   top: MediaQuery.of(context).viewPadding.top,
        //   left: 0,
        //   right: 0,
        //   child: TextField(
        //     readOnly: true,
        //     textAlign: TextAlign.center,
        //     controller: _textEditingController,
        //     decoration: const InputDecoration(
        //       border: InputBorder.none,
        //       focusedBorder: InputBorder.none,
        //     ),
        //   ),
        // ),
        Positioned(
          bottom: _defaultPadding,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ..._mediaButtons(
                  cameraEnabled: cameraEnabled, microEnabled: microEnabled),
              //  _endCallButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fullConversation({
    required bool cameraEnabled,
    required bool microEnabled,
  }) {
    const previewSize = 0.3;
    final previewWidth = MediaQuery.of(context).size.width * previewSize;
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
            height: previewWidth *
                _localRenderer.videoWidth /
                _localRenderer.videoHeight,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ..._mediaButtons(
                  cameraEnabled: cameraEnabled, microEnabled: microEnabled),
              //  _endCallButton(),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _endCallButton() {
  //   return FloatingActionButton(
  //     onPressed: () => _cubit.hangUp(_localRenderer),
  //     backgroundColor: Colors.red,
  //     child: const Icon(
  //       Icons.phone,
  //       color: Colors.white,
  //     ),
  //   );
  // }

  List<Widget> _mediaButtons(
      {required bool microEnabled, required bool cameraEnabled}) {
    final _cubit = context.read<RoomBloc>();
    return [
      FloatingActionButton(
        onPressed: () {
          if (cameraEnabled) {
            _cubit.disableVideo();
          } else {
            _cubit.enableVideo();
          }
        },
        backgroundColor: cameraEnabled ? Colors.blueAccent : Colors.white,
        child: Icon(
          cameraEnabled ? Icons.videocam : Icons.videocam_off,
          color: cameraEnabled ? Colors.white : Colors.red,
        ),
      ),
      FloatingActionButton(
        onPressed: () {
          if (microEnabled) {
            _cubit.disableAudio();
          } else {
            _cubit.enableAudio();
          }
        },
        backgroundColor: microEnabled ? Colors.blueAccent : Colors.white,
        child: Icon(
          microEnabled ? Icons.mic : Icons.mic_off,
          color: microEnabled ? Colors.white : Colors.red,
        ),
      ),
    ];
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc_flutter/blocs/create_room_bloc/create_room_bloc.dart';
import 'package:webrtc_flutter/blocs/room_bloc/cubit/room_cubit.dart';
import 'package:webrtc_flutter/blocs/room_bloc/cubit/room_state.dart';
import 'package:webrtc_flutter/common/utils/utils.dart';
import 'package:webrtc_flutter/router/router.dart';

import '../widgets/widgets.dart';

@RoutePage()
// class CreateRoomScreen extends StatefulWidget {
//   const CreateRoomScreen({super.key, required this.remoteRenderer});
//   final RTCVideoRenderer remoteRenderer;

//   @override
//   State<CreateRoomScreen> createState() => _CreateRoomScreenState();
// }

// class _CreateRoomScreenState extends State<CreateRoomScreen> {
//   late TextEditingController roomNameController;
//   late TextEditingController maxUserCountController;
//   final _formKey = GlobalKey<FormState>();
//   final utils = Utils();
//   late List<MenuItem> menuItems;

//   @override
//   void initState() {
//     maxUserCountController = TextEditingController(text: '2');
//     roomNameController = TextEditingController();
//     context.read<CreateRoomBloc>().add(GetLanguagesList());
//     super.initState();
//   }

//   @override
//   void dispose() {
//     maxUserCountController.dispose();
//     roomNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width * 0.82;
//     final TextEditingController menuController = TextEditingController();
//     return BlocConsumer<CreateRoomBloc, CreateRoomState>(
//       listener: (context, state) {
//         if (state is CreateRoomInSuccess) {
//           AutoRouter.of(context).pushAndPopUntil(
//               RoomRoute(
//                   roomModel: state.roomModel,
//                   remoteRenderer: widget.remoteRenderer),
//               predicate: (route) => false);
//         }
//       },
//       builder: (context, state) {
//         if (state is RoomLanguagesListLoaded) {
//           menuItems = state.languagesList
//               .map(
//                 (e) => MenuItem(e.code, e.name),
//               )
//               .toList();
//           return Scaffold(
//             body: CustomScrollView(
//               slivers: [
//                 const SliverAppBar(
//                   title: Text('Create Room'),
//                 ),
//                 SliverToBoxAdapter(
//                   child: CreateRoomWidget(
//                     roomNameController: roomNameController,
//                     maxUserCountController: maxUserCountController,
//                     formKey: _formKey,
//                     utils: utils,
//                     onTap: () {},
//                     width: width,
//                     menuController: menuController,
//                     menuItems: menuItems,
//                     remoteRender: widget.remoteRenderer,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator.adaptive(),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key, required this.remoteRenderer});
  final RTCVideoRenderer remoteRenderer;

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  late TextEditingController roomNameController;
  late TextEditingController maxUserCountController;
  final _formKey = GlobalKey<FormState>();
  final utils = Utils();
  late List<MenuItem> menuItems = [MenuItem('biba', 'boba')];

  @override
  void initState() {
    maxUserCountController = TextEditingController(text: '2');
    roomNameController = TextEditingController();
    context.read<CreateRoomBloc>().add(GetLanguagesList());
    super.initState();
  }

  @override
  void dispose() {
    maxUserCountController.dispose();
    roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.82;
    final TextEditingController menuController = TextEditingController();
    return BlocConsumer<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state.roomModel != null) {
          AutoRouter.of(context).pushAndPopUntil(
              RoomRoute(
                  roomModel: state.roomModel!,
                  remoteRenderer: widget.remoteRenderer),
              predicate: (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text('Create Room'),
              ),
              SliverToBoxAdapter(
                child: CreateRoomWidget(
                  roomNameController: roomNameController,
                  maxUserCountController: maxUserCountController,
                  formKey: _formKey,
                  utils: utils,
                  onTap: () {},
                  width: width,
                  menuController: menuController,
                  menuItems: menuItems,
                  remoteRender: widget.remoteRenderer,
                ),
              ),
            ],
          ),
        );

        // return const Scaffold(
        //   body: Center(
        //     child: CircularProgressIndicator.adaptive(),
        //   ),
        // );
      },
    );
  }
}

class MenuItem {
  final String code;
  final String label;

  MenuItem(
    this.code,
    this.label,
  );
}

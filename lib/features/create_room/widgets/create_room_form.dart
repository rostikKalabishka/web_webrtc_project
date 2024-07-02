import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/blocs/create_room_bloc/create_room_bloc.dart';
import 'package:webrtc_flutter/blocs/room_bloc/room_bloc.dart';
import 'package:webrtc_flutter/common/utils/utils.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/models.dart';
import 'package:webrtc_flutter/features/create_room/view/create_room.dart';
import 'package:webrtc_flutter/router/router.dart';
import 'package:webrtc_flutter/ui/widgets/base_dropdown_menu.dart';

import '../../../ui/ui.dart';

class CreateRoomWidget extends StatefulWidget {
  const CreateRoomWidget({
    super.key,
    required this.roomNameController,
    required this.maxUserCountController,
    required this.formKey,
    required this.utils,
    required this.onTap,
    required this.width,
    required this.menuController,
    required this.menuItems,
  });

  final TextEditingController roomNameController;
  final TextEditingController maxUserCountController;

  final GlobalKey<FormState> formKey;
  final Utils utils;
  final VoidCallback onTap;

  final double width;
  final TextEditingController menuController;
  final List<MenuItem> menuItems;

  @override
  _CreateRoomWidgetState createState() => _CreateRoomWidgetState();
}

class _CreateRoomWidgetState extends State<CreateRoomWidget> {
  MenuItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: widget.formKey,
      child: Center(
        child: BaseContainer(
          height: MediaQuery.of(context).size.height * 0.45,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextField(
                validator: (value) => widget.utils.usernameValidator(value),
                controller: widget.roomNameController,
                hintText: 'Room name',
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                validator: (value) => widget.utils.onlyNumber(value),
                hintText: 'Enter user count',
                controller: widget.maxUserCountController,
                keyboardType: TextInputType.name,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BaseDropdownMenu(
                  width: widget.width,
                  menuController: widget.menuController,
                  menuItems: widget.menuItems,
                  onSelected: (MenuItem? menu) {
                    setState(() {
                      selectedMenu = menu;
                    });
                  },
                ),
              ),
              CustomButton(
                onTap: () => _createRoom(),
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(16),
                child: Text(
                  'Create room',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _createRoom() {
    if (selectedMenu != null && widget.formKey.currentState!.validate()) {
      try {
        final roomName = widget.roomNameController.text;
        final userCountText = widget.maxUserCountController.text;
        final userCount = int.tryParse(userCountText);

        if (userCount == null) {
          print('Invalid user count: $userCountText');
          return;
        }

        final roomLanguage = LanguagesModel(
          name: selectedMenu!.label,
          code: selectedMenu!.code,
        );

        final roomModel = RoomModel(
          id: '',
          roomName: roomName,
          roomLanguage: roomLanguage,
          roomUsersList: [],
          maxUserInRoom: userCount,
          createTimeRoom: DateTime.now(),
        );

        context
            .read<CreateRoomBloc>()
            .add(CreateRoom(createRoomModel: roomModel));
        print('Room model created successfully: ${roomModel.toJson()}');
      } catch (e) {
        print('Error creating room model: $e');
      }
    } else {
      print('No menu selected');
    }
  }
}

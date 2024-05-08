import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webrtc_flutter/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:webrtc_flutter/blocs/user_bloc/user_bloc.dart';
import 'package:webrtc_flutter/ui/theme/image_const.dart';

import '../../../ui/ui.dart';

class ShowUpdateUserInfoBottomSheet extends StatefulWidget {
  const ShowUpdateUserInfoBottomSheet(
      {super.key, required this.usernameController});
  final TextEditingController usernameController;

  @override
  State<ShowUpdateUserInfoBottomSheet> createState() =>
      _ShowUpdateUserInfoBottomSheetState();
}

class _ShowUpdateUserInfoBottomSheetState
    extends State<ShowUpdateUserInfoBottomSheet> {
  File? _pickedFile;
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UserBloc>();
    final theme = Theme.of(context);
    return BaseBottomSheet(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      AutoRouter.of(context).pop();
                      widget.usernameController.clear();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            GestureDetector(
              onTap: () async {
                await _pickImage(context);
              },
              child: CircleAvatar(
                backgroundImage: _pickedFile != null
                    ? FileImage(_pickedFile!)
                    : (bloc.state.myUser.userImage.isNotEmpty
                        ? NetworkImage(bloc.state.myUser.userImage)
                        : const AssetImage(ImageConst.userPlaceholder)
                            as ImageProvider),
                radius: 50,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
                controller: widget.usernameController,
                keyboardType: TextInputType.name),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onTap: () {
                _updateUserInfo(bloc, context);
              },
              color: theme.primaryColor,
              child: Text(
                'Save changes',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserInfo(UserBloc bloc, BuildContext context) {
    if (widget.usernameController.text.isNotEmpty ||
        _pickedFile?.path != null) {
      final username = widget.usernameController.text;
      bloc.add(UpdateUserInfo(
        username: username.isNotEmpty ? username : bloc.state.myUser.username,
        userId: context.read<AuthenticationBloc>().state.user!.uid,
        file: _pickedFile?.path ?? '',
      ));
      widget.usernameController.clear();
      AutoRouter.of(context).pop();
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 40);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Theme.of(context).colorScheme.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _pickedFile = File(croppedFile.path);
        });
      }
    }
  }
}

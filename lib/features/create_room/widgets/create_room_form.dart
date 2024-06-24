import 'package:flutter/material.dart';
import 'package:webrtc_flutter/common/utils/utils.dart';

import '../../../ui/ui.dart';

class CreateRoomWidget extends StatelessWidget {
  const CreateRoomWidget(
      {super.key,
      required this.roomNameController,
      required this.maxUserCountController,
      required this.formKey,
      required this.utils,
      required this.onTap,
      required});
  final TextEditingController roomNameController;
  final TextEditingController maxUserCountController;

  final GlobalKey<FormState> formKey;
  final Utils utils;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: formKey,
      child: Center(
        child: BaseContainer(
          height: MediaQuery.of(context).size.height * 0.35,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextField(
                validator: (value) => utils.usernameValidator(value),
                controller: roomNameController,
                hintText: 'Room name',
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                validator: (value) => utils.passwordValidator(value),
                hintText: 'Enter user count',
                controller: maxUserCountController,
                keyboardType: TextInputType.name,
              ),
              CustomButton(
                onTap: onTap,
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
}

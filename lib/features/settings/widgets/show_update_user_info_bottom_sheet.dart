import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/blocs/user_bloc/user_bloc.dart';
import 'package:webrtc_flutter/ui/theme/image_const.dart';

import '../../../ui/ui.dart';

class ShowUpdateUserInfoBottomSheet extends StatelessWidget {
  const ShowUpdateUserInfoBottomSheet(
      {super.key, required this.usernameController});
  final TextEditingController usernameController;

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
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            CircleAvatar(
              backgroundImage: bloc.state.myUser.userImage.isNotEmpty
                  ? NetworkImage(bloc.state.myUser.userImage)
                  : const AssetImage(ImageConst.userPlaceholder)
                      as ImageProvider,
              radius: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
                controller: usernameController,
                keyboardType: TextInputType.name),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onTap: () {},
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
}

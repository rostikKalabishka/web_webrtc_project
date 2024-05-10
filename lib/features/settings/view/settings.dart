import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/blocs/sing_in_bloc/sing_in_bloc.dart';
import 'package:webrtc_flutter/blocs/user_bloc/user_bloc.dart';
import 'package:webrtc_flutter/features/settings/widgets/show_update_user_info_bottom_sheet.dart';
import 'package:webrtc_flutter/router/router.dart';
import 'package:webrtc_flutter/ui/ui.dart';

import '../../../blocs/theme_cubit/theme_cubit.dart';
import '../../../ui/theme/image_const.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = context.watch<ThemeCubit>().state.isDark;
    final theme = Theme.of(context);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text('Settings'),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _showUpdateUserInfoBottomSheet(context);
                      },
                      child: BaseContainer(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    state.myUser.userImage.isNotEmpty
                                        ? NetworkImage(state.myUser.userImage)
                                        : const AssetImage(
                                                ImageConst.userPlaceholder)
                                            as ImageProvider,
                                radius: 30,
                              ),
                              title: Text(state.myUser.username,
                                  overflow: TextOverflow.ellipsis),
                              subtitle: Text(
                                state.myUser.email,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: theme.hintColor,
                              ))),
                    ),
                    BaseContainer(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dark Mode',
                            style: theme.textTheme.bodyLarge,
                          ),
                          Switch.adaptive(
                              value: isDarkTheme,
                              onChanged: (value) =>
                                  _setThemeBrightness(context, value)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: CustomButton(
                        color: theme.primaryColor,
                        onTap: () {
                          context.read<SingInBloc>().add(SingOut());
                          AutoRouter.of(context).pushAndPopUntil(
                              const LoaderRoute(),
                              predicate: (route) => false);
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Text(
                          'Logout',
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setThemeBrightness(BuildContext context, bool value) {
    context.read<ThemeCubit>().setThemeBrightness(
          value ? Brightness.dark : Brightness.light,
        );
  }

  Future _showUpdateUserInfoBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return ShowUpdateUserInfoBottomSheet(
            usernameController: _usernameController,
          );
        });
  }
}

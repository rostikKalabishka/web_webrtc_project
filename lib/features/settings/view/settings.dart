import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/blocs/sing_in_bloc/sing_in_bloc.dart';
import 'package:webrtc_flutter/router/router.dart';
import 'package:webrtc_flutter/ui/ui.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = true;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Settings'),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                BaseContainer(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/2/23/Lil-Peep_PrettyPuke_Photoshoot.png'),
                          radius: 30,
                        ),
                        title: const Text('Rostik Kalabishka',
                            overflow: TextOverflow.ellipsis),
                        subtitle: const Text(
                          'rostik31052002@gmail.com',
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: theme.hintColor,
                        ))),
                BaseContainer(
                  margin: const EdgeInsets.all(12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark Mode',
                        style: theme.textTheme.bodyLarge,
                      ),
                      Switch.adaptive(
                          value: darkMode,
                          onChanged: (value) {
                            setState(() {
                              darkMode = !darkMode;
                            });
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: CustomButton(
                    color: theme.primaryColor,
                    onTap: () {
                      context.read<SingInBloc>().add(SingOut());
                      AutoRouter.of(context).pushAndPopUntil(
                          const LoaderRoute(),
                          predicate: (route) => false);
                    },
                    child: Text(
                      'Logout',
                      style: theme.textTheme.bodyLarge
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
  }
}

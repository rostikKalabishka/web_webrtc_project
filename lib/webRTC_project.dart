import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webrtc_flutter/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:webrtc_flutter/blocs/theme_cubit/theme_cubit.dart';
import 'package:webrtc_flutter/domain/factory/factory_bloc_provider.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/user_repository.dart';
import 'package:webrtc_flutter/router/router.dart';
import 'package:webrtc_flutter/ui/theme/theme.dart';

class WebRTCProject extends StatefulWidget {
  const WebRTCProject({super.key, required this.preferences});
  final SharedPreferences preferences;

  @override
  State<WebRTCProject> createState() => _WebRTCProjectState();
}

class _WebRTCProjectState extends State<WebRTCProject> {
  final _appRouter = AppRouter();
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationBloc(myUserRepository: userRepository),
      child: FactoryBlocProvider(
        preferences: widget.preferences,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: state.isDark ? darkTheme : lightTheme,
                routerConfig: _appRouter.config());
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webrtc_flutter/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:webrtc_flutter/blocs/create_room_bloc/create_room_bloc.dart';
import 'package:webrtc_flutter/blocs/room_bloc/cubit/room_cubit.dart';

import 'package:webrtc_flutter/blocs/room_list_bloc/room_list_bloc.dart';
import 'package:webrtc_flutter/blocs/sing_in_bloc/sing_in_bloc.dart';
import 'package:webrtc_flutter/blocs/sing_up_bloc/sign_up_bloc.dart';
import 'package:webrtc_flutter/blocs/theme_cubit/theme_cubit.dart';
import 'package:webrtc_flutter/blocs/user_bloc/user_bloc.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository.dart';
import 'package:webrtc_flutter/domain/repositories/settings_repository/settings_repository.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/user_repository.dart';

class FactoryBlocProvider extends StatefulWidget {
  const FactoryBlocProvider(
      {super.key, required this.child, required this.preferences});
  final Widget child;
  final SharedPreferences preferences;

  @override
  State<FactoryBlocProvider> createState() => _FactoryBlocProviderState();
}

class _FactoryBlocProviderState extends State<FactoryBlocProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = UserRepository();
    final RoomRepository roomRepository = RoomRepository();
    final SettingsRepository settingsRepository =
        SettingsRepository(preferences: widget.preferences);
    final singInBloc = SingInBloc(myUserRepository: userRepository);
    final signUpBloc = SignUpBloc(myUserRepository: userRepository);
    final userBloc = UserBloc(myUserRepository: userRepository);
    final themeCubit = ThemeCubit(settingsRepository: settingsRepository);
    // final RoomBloc roomBloc = RoomBloc(roomRepository: roomRepository);
    final RoomBloc roomBloc = RoomBloc(roomRepository: roomRepository);
    final CreateRoomBloc createRoomBloc =
        CreateRoomBloc(roomRepository: roomRepository);
    final RoomListBloc roomListBloc =
        RoomListBloc(roomRepository: roomRepository);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => singInBloc),
        BlocProvider(create: (_) => signUpBloc),
        BlocProvider(create: (_) => themeCubit),
        BlocProvider(create: (_) => roomBloc),
        BlocProvider(create: (_) => roomListBloc),
        BlocProvider(create: (_) => createRoomBloc),
        BlocProvider(
            create: (_) => userBloc
              ..add(GetCurrentUser(
                  currentUser:
                      context.read<AuthenticationBloc>().state.user!))),
      ],
      child: widget.child,
    );
  }
}

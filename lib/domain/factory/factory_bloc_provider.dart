import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:webrtc_flutter/blocs/sing_in_bloc/sing_in_bloc.dart';
import 'package:webrtc_flutter/blocs/sing_up_bloc/sign_up_bloc.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository.dart';

import '../repositories/user_repository/user_repository.dart';

class FactoryBlocProvider extends StatefulWidget {
  const FactoryBlocProvider({super.key, required this.child, r});
  final Widget child;

  @override
  State<FactoryBlocProvider> createState() => _FactoryBlocProviderState();
}

class _FactoryBlocProviderState extends State<FactoryBlocProvider> {
  final UserRepository userRepository = UserRepository();
  final RoomRepository roomRepository = RoomRepository();
  @override
  Widget build(BuildContext context) {
    final authenticationBloc =
        AuthenticationBloc(myUserRepository: userRepository);
    final singInBloc = SingInBloc(myUserRepository: userRepository);
    final signUpBloc = SignUpBloc(myUserRepository: userRepository);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => authenticationBloc),
        BlocProvider(create: (_) => singInBloc),
        BlocProvider(create: (_) => signUpBloc)
      ],
      child: widget.child,
    );
  }
}
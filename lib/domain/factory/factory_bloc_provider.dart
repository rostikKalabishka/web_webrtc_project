import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/blocs/authentication_bloc/authentication_bloc.dart';

class FactoryBlocProvider extends StatefulWidget {
  const FactoryBlocProvider({super.key, required this.child});
  final Widget child;

  @override
  State<FactoryBlocProvider> createState() => _FactoryBlocProviderState();
}

class _FactoryBlocProviderState extends State<FactoryBlocProvider> {
  @override
  Widget build(BuildContext context) {
    final authenticationBloc = AuthenticationBloc();
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => authenticationBloc)],
      child: widget.child,
    );
  }
}

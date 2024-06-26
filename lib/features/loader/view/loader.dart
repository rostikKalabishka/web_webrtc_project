import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:webrtc_flutter/router/router.dart';

@RoutePage()
class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) =>
          current != const AuthenticationState.unknown(),
      listener: (context, state) {
        print('Authentication state changed: $state');
        navigateTo(context, state);
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  void navigateTo(BuildContext context, AuthenticationState state) {
    if (state.status == AuthenticationStatus.authenticated) {
      AutoRouter.of(context).pushAndPopUntil(const HomeRouteMobile(),
          predicate: (route) => false);
    } else {
      AutoRouter.of(context)
          .pushAndPopUntil(const LoginRoute(), predicate: (route) => false);
    }
  }
}

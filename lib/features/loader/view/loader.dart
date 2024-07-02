import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:webrtc_flutter/router/router.dart';

@RoutePage()
class LoaderScreen extends StatelessWidget {
  const LoaderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      navigateTo(context, state);
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    });
  }

  void navigateTo(BuildContext context, AuthenticationState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigateToNextScreen =
          state.status == AuthenticationStatus.authenticated
              ? const HomeRouteMobile()
              : const LoginRoute();

      AutoRouter.of(context)
          .pushAndPopUntil(navigateToNextScreen, predicate: (route) => false);
    });
  }
}

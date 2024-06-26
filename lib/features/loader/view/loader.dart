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
  void initState() {
    super.initState();

    // Викликаємо navigateTo після завершення побудови віджета
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      navigateTo(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  void navigateTo(BuildContext context) {
    final authBloc = context.read<AuthenticationBloc>();
    final state = authBloc.state;

    if (state.status == AuthenticationStatus.authenticated) {
      AutoRouter.of(context).pushAndPopUntil(const HomeRouteMobile(),
          predicate: (route) => false);
    } else {
      AutoRouter.of(context)
          .pushAndPopUntil(const LoginRoute(), predicate: (route) => false);
    }
  }
}

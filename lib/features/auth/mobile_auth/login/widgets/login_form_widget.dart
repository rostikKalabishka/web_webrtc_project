import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:webrtc_flutter/router/router.dart';

import '../../../../../ui/ui.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: BaseContainer(
        height: MediaQuery.of(context).size.height * 0.35,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextField(
              controller: emailController,
            ),
            CustomTextField(
              controller: passwordController,
              obscureText: true,
            ),
            CustomButton(
              onTap: () {
                AutoRouter.of(context).pushAndPopUntil(const HomeRouteMobile(),
                    predicate: (route) => false);
              },
              color: theme.primaryColor,
              child: Text(
                'Login',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

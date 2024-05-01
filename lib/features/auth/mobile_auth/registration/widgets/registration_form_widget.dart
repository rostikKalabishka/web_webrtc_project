import 'package:flutter/material.dart';

import '../../../../../ui/ui.dart';

class RegistrationFormWidget extends StatelessWidget {
  const RegistrationFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.usernameController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: BaseContainer(
        height: MediaQuery.of(context).size.height * 0.5,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextField(
              hintText: 'Email',
              controller: emailController,
            ),
            CustomTextField(
              hintText: 'Username',
              controller: usernameController,
            ),
            CustomTextField(
              hintText: 'Password',
              controller: passwordController,
              obscureText: true,
            ),
            CustomTextField(
              hintText: 'Confirm password',
              controller: confirmPasswordController,
              obscureText: true,
            ),
            CustomButton(
              onTap: () {},
              color: theme.primaryColor,
              child: Text(
                'Registration',
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

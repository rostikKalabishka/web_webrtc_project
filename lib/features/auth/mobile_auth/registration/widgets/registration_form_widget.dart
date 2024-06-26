import 'package:flutter/material.dart';
import 'package:webrtc_flutter/common/utils/utils.dart';

import '../../../../../ui/ui.dart';

class RegistrationFormWidget extends StatefulWidget {
  const RegistrationFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.usernameController,
    required this.formKey,
    required this.utils,
    required this.onTap,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController usernameController;
  final GlobalKey<FormState> formKey;
  final Utils utils;
  final VoidCallback onTap;

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  bool obscureTextPassword = true;
  bool obscureTextPasswordConfirm = true;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: widget.formKey,
      child: Center(
        child: BaseContainer(
          height: MediaQuery.of(context).size.height * 0.55,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextField(
                validator: (val) => widget.utils.emailValidator(val),
                hintText: 'Email',
                controller: widget.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                validator: (val) => widget.utils.usernameValidator(val),
                hintText: 'Username',
                controller: widget.usernameController,
                keyboardType: TextInputType.name,
              ),
              CustomTextField(
                validator: (val) => widget.utils.passwordValidator(val),
                hintText: 'Password',
                controller: widget.passwordController,
                obscureText: obscureTextPassword,
                keyboardType: TextInputType.text,
                suffixIcon: IconButton(
                  onPressed: () {
                    obscureTextPassword = !obscureTextPassword;
                    setState(() {});
                  },
                  icon: obscureTextPassword
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
              ),
              CustomTextField(
                validator: (val) => widget.utils.confirmPasswordValidator(
                    val!, widget.passwordController.text),
                hintText: 'Confirm password',
                controller: widget.confirmPasswordController,
                obscureText: obscureTextPasswordConfirm,
                keyboardType: TextInputType.text,
                suffixIcon: IconButton(
                  onPressed: () {
                    obscureTextPasswordConfirm = !obscureTextPasswordConfirm;
                    setState(() {});
                  },
                  icon: obscureTextPasswordConfirm
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
              ),
              CustomButton(
                onTap: widget.onTap,
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(16),
                child: Text(
                  'Registration',
                  style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/blocs/sing_in_bloc/sing_in_bloc.dart';
import 'package:webrtc_flutter/common/utils/utils.dart';
import 'package:webrtc_flutter/router/router.dart';

import '../../../../../ui/ui.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.utils,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  final GlobalKey<FormState> formKey;
  final Utils utils;

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: widget.formKey,
      child: Center(
        child: BaseContainer(
          height: MediaQuery.of(context).size.height * 0.35,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextField(
                validator: (value) => widget.utils.emailValidator(value),
                controller: widget.emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                validator: (value) => widget.utils.passwordValidator(value),
                hintText: 'Password',
                controller: widget.passwordController,
                obscureText: obscureText,
                keyboardType: TextInputType.name,
                suffixIcon: IconButton(
                  onPressed: () {
                    obscureText = !obscureText;
                    setState(() {});
                  },
                  icon: obscureText
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
              ),
              CustomButton(
                onTap: () {
                  _signIn(context);
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
      ),
    );
  }

  void _signIn(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      context.read<SingInBloc>().add(SingInRequired(
          password: widget.passwordController.text,
          email: widget.emailController.text));
      AutoRouter.of(context)
          .pushAndPopUntil(const LoaderRoute(), predicate: (route) => false);
    }
  }
}

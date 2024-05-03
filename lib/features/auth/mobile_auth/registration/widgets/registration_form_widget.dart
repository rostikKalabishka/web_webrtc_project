import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/blocs/sing_up_bloc/sign_up_bloc.dart';
import 'package:webrtc_flutter/common/utils/utils.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';

import '../../../../../ui/ui.dart';

class RegistrationFormWidget extends StatelessWidget {
  const RegistrationFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.usernameController,
    required this.formKey,
    required this.utils,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController usernameController;
  final GlobalKey<FormState> formKey;
  final Utils utils;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: formKey,
      child: Center(
        child: BaseContainer(
          height: MediaQuery.of(context).size.height * 0.55,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextField(
                validator: (val) => utils.emailValidator(val),
                hintText: 'Email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                validator: (val) => utils.usernameValidator(val),
                hintText: 'Username',
                controller: usernameController,
                keyboardType: TextInputType.name,
              ),
              CustomTextField(
                validator: (val) => utils.passwordValidator(val),
                hintText: 'Password',
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
              ),
              CustomTextField(
                validator: (val) => utils.confirmPasswordValidator(
                    val!, passwordController.text),
                hintText: 'Confirm password',
                controller: confirmPasswordController,
                obscureText: true,
                keyboardType: TextInputType.text,
              ),
              CustomButton(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    MyUserModel myUserModel = MyUserModel.empty.copyWith(
                        email: emailController.text,
                        username: usernameController.text);
                    context.read<SignUpBloc>().add(SignUpRequired(
                        myUserModel: myUserModel,
                        password: passwordController.text));
                  }
                },
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
      ),
    );
  }
}

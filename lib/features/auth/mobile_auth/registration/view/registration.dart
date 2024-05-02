import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:webrtc_flutter/ui/theme/image_const.dart';

import '../widgets/widgets.dart';

@RoutePage()
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  late TextEditingController confirmPasswordController;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              centerTitle: true,
              title: Text(
                'Registration',
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 1.7,
                child: Image.asset(ImageConst.imageForAuth),
              ),
            ),
            SliverToBoxAdapter(
              child: RegistrationFormWidget(
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
                usernameController: usernameController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

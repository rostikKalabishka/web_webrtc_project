import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/blocs/sing_up_bloc/sign_up_bloc.dart';
import 'package:webrtc_flutter/common/utils/utils.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';
import 'package:webrtc_flutter/router/router.dart';

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

  final _formKey = GlobalKey<FormState>();
  final utils = Utils();
  String error = '';
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
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        errorHandler(state, context, theme);
      },
      builder: (context, state) {
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
                    formKey: _formKey,
                    utils: utils,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void errorHandler(SignUpState state, BuildContext context, ThemeData theme) {
    if (state is SingUpFailure) {
      setState(() {
        error = state.error.toString();
      });
      utils.errorSnackBar(context, theme, error);
    } else if (state is SingUpProcess) {
      AutoRouter.of(context)
          .pushAndPopUntil(const LoaderRoute(), predicate: (route) => false);
    } else {
      setState(() {
        error = '';
      });
    }
  }

  void formController(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      MyUserModel userModel = MyUserModel(
          id: '',
          email: emailController.text,
          username: usernameController.text,
          userImage: '');

      context.read<SignUpBloc>().add(SignUpRequired(
          password: passwordController.text, myUserModel: userModel));
    }
  }
}

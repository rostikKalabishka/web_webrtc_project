import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/router/router.dart';
import 'package:webrtc_flutter/ui/theme/image_const.dart';
import '../../../../../blocs/sing_in_bloc/sing_in_bloc.dart';
import '../../../../../common/utils/utils.dart';
import '../widgets/login_form_widget.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();
  final utils = Utils();
  String error = '';

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<SingInBloc, SingInState>(
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
                    'Login',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                SliverToBoxAdapter(
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.asset(ImageConst.imageForAuth),
                  ),
                ),
                SliverToBoxAdapter(
                  child: LoginFormWidget(
                    emailController: emailController,
                    passwordController: passwordController,
                    formKey: _formKey,
                    utils: utils,
                    onTap: () {
                      formController(context);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text('Don`t have an account? '),
                        GestureDetector(
                          child: const Text(
                            'Register now',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            AutoRouter.of(context)
                                .push(const RegistrationRoute());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void errorHandler(SingInState state, BuildContext context, ThemeData theme) {
    if (state is SingInFailure) {
      setState(() {
        error = state.error.toString();
      });
      utils.errorSnackBar(context, theme, error);
    } else if (state is SingInSuccess) {
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
      context.read<SingInBloc>().add(SingInRequired(
          password: passwordController.text, email: emailController.text));
    }
  }
}

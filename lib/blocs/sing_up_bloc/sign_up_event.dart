part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequired extends SignUpEvent {
  final MyUserModel myUserModel;
  final String password;

  const SignUpRequired({required this.myUserModel, required this.password});

  @override
  List<Object> get props => super.props..addAll([myUserModel, password]);
}

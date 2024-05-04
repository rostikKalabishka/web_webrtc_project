part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}

class SingUpProcess extends SignUpState {}

class SingUpSuccess extends SignUpState {}

class SingUpFailure extends SignUpState {
  final Object error;

  const SingUpFailure({required this.error});

  @override
  List<Object> get props => super.props..add(error);
}

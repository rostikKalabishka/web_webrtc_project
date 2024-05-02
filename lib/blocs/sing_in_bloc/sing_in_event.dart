part of 'sing_in_bloc.dart';

sealed class SingInEvent extends Equatable {
  const SingInEvent();

  @override
  List<Object> get props => [];
}

class SingInRequired extends SingInEvent {
  final String email;
  final String password;

  const SingInRequired({required this.email, required this.password});

  @override
  List<Object> get props => super.props..addAll([email, password]);
}

class SingOut extends SingInEvent {}

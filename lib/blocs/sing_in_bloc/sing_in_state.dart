part of 'sing_in_bloc.dart';

sealed class SingInState extends Equatable {
  const SingInState();

  @override
  List<Object> get props => [];
}

final class SingInInitial extends SingInState {}

class SingInProcess extends SingInState {}

class SingInSuccess extends SingInState {}

class SingOutProcess extends SingInState {}

class SingOutSuccess extends SingInState {}

class SingInFailure extends SingInState {
  final Object error;

  const SingInFailure({required this.error});

  @override
  List<Object> get props => super.props..add(error);
}

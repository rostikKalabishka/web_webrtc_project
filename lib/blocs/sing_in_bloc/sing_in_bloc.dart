import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/user_repository.dart';

part 'sing_in_event.dart';
part 'sing_in_state.dart';

class SingInBloc extends Bloc<SingInEvent, SingInState> {
  final UserRepository userRepository;
  SingInBloc({required UserRepository myUserRepository})
      : userRepository = myUserRepository,
        super(SingInInitial()) {
    on<SingInEvent>((event, emit) async {
      if (event is SingInRequired) {
        _singIn(event, emit);
      } else if (event is SingOut) {
        _singOut(event, emit);
      }
    });
  }

  Future<void> _singIn(SingInRequired event, emit) async {
    emit(SignInProcess());
    try {
      await userRepository.singIn(event.email, event.password);
      emit(SignInSuccess());
    } catch (e) {
      log(e.toString());
      emit(SignInFailure(error: e));
    }
  }

  Future<void> _singOut(SingOut event, emit) async {
    emit(SignInProcess());
    try {
      await userRepository.logOut();
      emit(SignInSuccess());
    } catch (e) {
      log(e.toString());
      emit(SignInFailure(error: e));
    }
  }
}
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';

import '../../domain/repositories/user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository userRepository;
  SignUpBloc({required UserRepository myUserRepository})
      : userRepository = myUserRepository,
        super(SignUpInitial()) {
    on<SignUpEvent>((event, emit) async {
      if (event is SignUpRequired) {
        await _registration(event, emit);
      }
    });
  }

  Future<void> _registration(SignUpRequired event, emit) async {
    emit(SingUpProcess());
    try {
      await userRepository.registration(event.myUserModel, event.password);
      emit(SingUpSuccess());
    } catch (e) {
      emit(SingUpFailure(error: e));
    }
  }
}

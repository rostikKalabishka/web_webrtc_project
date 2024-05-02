import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';

import '../../domain/repositories/user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository userRepository;
  SignUpBloc({required UserRepository myUserRepository})
      : userRepository = myUserRepository,
        super(SignUpInitial()) {
    on<SignUpEvent>((event, emit) async {});
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';

import '../../domain/repositories/user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  late final StreamSubscription<MyUserModel?> _userSubscription;

  AuthenticationBloc({required UserRepository myUserRepository})
      : userRepository = myUserRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = userRepository.user.listen((user) {
      log('User subscription received: $user');
      add(AuthenticationUserChanged(user));
    });

    on<AuthenticationUserChanged>((event, emit) {
      final user = event.user;
      try {
        if (user != null) {
          print('User authenticated: $user');
          emit(AuthenticationState.authenticated(user));
        } else {
          emit(const AuthenticationState.unauthenticated());
        }
      } catch (e) {
        log('Error: $e');
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

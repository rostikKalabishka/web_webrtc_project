import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<UserEvent>((event, emit) async {
      if (event is GetCurrentUser) {
        await _getCurrentUser(event, emit);
      } else if (event is GetCurrentUser) {
        await _updateUserInfo(event, emit);
      }
    });
  }
  Future<void> _getCurrentUser(GetCurrentUser event, emit) async {}

  Future<void> _updateUserInfo(GetCurrentUser event, emit) async {}
}

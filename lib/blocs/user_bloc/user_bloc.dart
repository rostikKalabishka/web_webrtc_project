import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc({required UserRepository myUserRepository})
      : userRepository = myUserRepository,
        super(const UserState()) {
    on<UserEvent>((event, emit) async {
      if (event is GetCurrentUser) {
        await _getCurrentUser(event, emit);
      } else if (event is UpdateUserInfo) {
        await _updateUserInfo(event, emit);
      }
    });
  }
  Future<void> _getCurrentUser(GetCurrentUser event, emit) async {
    emit(state.copyWith(myUserStatus: MyUserStatus.loading));
    try {
      final MyUserModel myUser = await userRepository.getMyUser(event.uid);

      emit(state.copyWith(myUserStatus: MyUserStatus.success, myUser: myUser));
    } catch (e) {
      emit(state.copyWith(myUserStatus: MyUserStatus.failure, error: e));
    }
  }

  Future<void> _updateUserInfo(UpdateUserInfo event, emit) async {
    emit(state.copyWith(updateUserInfoState: UpdateUserInfoState.loading));
    try {
      MyUserModel myUser = state.myUser.copyWith(username: event.username);

      if (event.file.isNotEmpty) {
        final String image =
            await userRepository.uploadPicture(event.file, event.userId);
        myUser = myUser.copyWith(userImage: image);
      }

      await userRepository.updateUserInfo(myUser);

      emit(state.copyWith(
          updateUserInfoState: UpdateUserInfoState.loaded, myUser: myUser));
    } catch (e) {
      emit(state.copyWith(
          updateUserInfoState: UpdateUserInfoState.failure, error: e));
    }
  }
}

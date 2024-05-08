part of 'user_bloc.dart';

enum UpdateUserInfoState { loading, loaded, failure }

enum MyUserStatus { success, loading, failure }

class UserState extends Equatable {
  const UserState({
    this.error = '',
    this.myUser = MyUserModel.empty,
    this.updateUserInfoState = UpdateUserInfoState.loading,
    this.myUserStatus = MyUserStatus.loading,
  });
  final Object error;
  final MyUserModel myUser;
  final UpdateUserInfoState updateUserInfoState;
  final MyUserStatus myUserStatus;

  UserState copyWith({
    Object? error,
    MyUserModel? myUser,
    UpdateUserInfoState? updateUserInfoState,
    MyUserStatus? myUserStatus,
  }) {
    return UserState(
        error: error ?? this.error,
        myUser: myUser ?? this.myUser,
        updateUserInfoState: updateUserInfoState ?? this.updateUserInfoState,
        myUserStatus: myUserStatus ?? this.myUserStatus);
  }

  @override
  List<Object> get props => [error, myUser, updateUserInfoState, myUserStatus];
}

part of 'user_bloc.dart';

enum UpdateUserInfoState { loading, loaded, failure }

enum MyUserStatus { success, loading, failure }

enum SingOutStatus { singOutSuccess, singOutProcess, singOutFailure }

class UserState extends Equatable {
  const UserState(
      {this.error = '',
      this.myUser = MyUserModel.empty,
      this.updateUserInfoState = UpdateUserInfoState.loading,
      this.myUserStatus = MyUserStatus.loading,
      this.singOutStatus = SingOutStatus.singOutProcess});
  final Object error;
  final MyUserModel myUser;
  final UpdateUserInfoState updateUserInfoState;
  final MyUserStatus myUserStatus;
  final SingOutStatus singOutStatus;

  UserState copyWith({
    Object? error,
    MyUserModel? myUser,
    UpdateUserInfoState? updateUserInfoState,
    MyUserStatus? myUserStatus,
    SingOutStatus? singOutStatus,
  }) {
    return UserState(
        error: error ?? this.error,
        myUser: myUser ?? this.myUser,
        updateUserInfoState: updateUserInfoState ?? this.updateUserInfoState,
        myUserStatus: myUserStatus ?? this.myUserStatus,
        singOutStatus: singOutStatus ?? this.singOutStatus);
  }

  @override
  List<Object> get props =>
      [error, myUser, updateUserInfoState, myUserStatus, singOutStatus];
}

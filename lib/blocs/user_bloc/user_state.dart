part of 'user_bloc.dart';

enum UpdateUserInfoState { loading, loaded, failure }

enum MyUserStatus { success, loading, failure }

class UserState extends Equatable {
  const UserState({this.error = '', this.myUser = MyUserModel.empty});
  final Object error;
  final MyUserModel myUser;

  @override
  List<Object> get props => [error, myUser];
}

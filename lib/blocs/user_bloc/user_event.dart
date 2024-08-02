part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentUser extends UserEvent {
  final MyUserModel currentUser;

  const GetCurrentUser({required this.currentUser});

  @override
  List<Object> get props => super.props..add(currentUser);
}

class SingOut extends UserEvent {}

class UpdateUserInfo extends UserEvent {
  final String file;
  final String userId;
  final String username;

  const UpdateUserInfo({
    required this.file,
    required this.userId,
    required this.username,
  });

  @override
  List<Object> get props => super.props..addAll([userId, userId, username]);
}

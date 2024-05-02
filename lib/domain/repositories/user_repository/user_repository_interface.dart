import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class UserRepositoryInterface {
  Future<MyUserModel> registration(
    MyUserModel userModel,
    String password,
  );

  Future<void> singIn(String email, String password);

  Future<void> resetPassword(String email);

  Future<void> logOut();

  Stream<User?> get user;

  Future<void> setUserData(MyUserModel user);

  Future<MyUserModel> getMyUser(String myUserId);

  Future<String> uploadPicture(String file, String userId);
}

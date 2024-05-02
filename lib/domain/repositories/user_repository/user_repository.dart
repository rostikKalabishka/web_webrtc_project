import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';

import 'user_repository_interface.dart';

class UserRepository implements UserRepositoryInterface {
  FirebaseAuth _firebaseAuth;
  UserRepository(FirebaseAuth? firebaseAuth)
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final usersCollection = FirebaseFirestore.instance.collection('user');
  @override
  Future<MyUser> getMyUser(String myUserId) {
    // TODO: implement getMyUser
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> registration() {
    // TODO: implement registration
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<void> setUserData(MyUser user) {
    // TODO: implement setUserData
    throw UnimplementedError();
  }

  @override
  Future<void> singIn(String email, String password) {
    // TODO: implement singIn
    throw UnimplementedError();
  }

  @override
  Future<String> uploadPicture(String file, String userId) {
    // TODO: implement uploadPicture
    throw UnimplementedError();
  }

  @override
  // TODO: implement user
  Stream<User?> get user => throw UnimplementedError();
}

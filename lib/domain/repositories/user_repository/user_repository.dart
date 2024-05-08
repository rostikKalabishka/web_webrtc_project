import 'dart:developer';
import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:webrtc_flutter/domain/repositories/user_repository/models/my_user_model.dart';

import 'user_repository_interface.dart';

class UserRepository implements UserRepositoryInterface {
  FirebaseAuth _firebaseAuth;
  UserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final usersCollection = FirebaseFirestore.instance.collection('user');
  @override
  Future<MyUserModel> getMyUser(String myUserId) async {
    try {
      return usersCollection
          .doc(myUserId)
          .get()
          .then((value) => MyUserModel.fromJson(value.data()!));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUserModel> registration(
    MyUserModel userModel,
    String password,
  ) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: userModel.email, password: password);
      userModel = userModel.copyWith(id: user.user?.uid);
      return userModel;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUserModel user) async {
    try {
      await usersCollection.doc(user.id).set(user.toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> singIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> uploadPicture(
    String file,
    String userId,
  ) async {
    try {
      File imageFile = File(file);
      Reference referenceStorageRef =
          FirebaseStorage.instance.ref().child('$userId//PP/${userId}_load');

      await referenceStorageRef.putFile(imageFile);
      String url = await referenceStorageRef.getDownloadURL();
      await usersCollection.doc(userId).update({'userImage': url});
      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateUserInfo(MyUserModel userModel) async {
    try {
      await usersCollection.doc(userModel.id).update(userModel.toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<User?> get user =>
      _firebaseAuth.authStateChanges().map((firebaseUser) {
        return firebaseUser;
      });
}

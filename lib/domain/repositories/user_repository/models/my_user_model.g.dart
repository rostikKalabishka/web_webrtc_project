// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyUserModel _$MyUserModelFromJson(Map<String, dynamic> json) => MyUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      userImage: json['userImage'] as String,
    );

Map<String, dynamic> _$MyUserModelToJson(MyUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'userImage': instance.userImage,
    };

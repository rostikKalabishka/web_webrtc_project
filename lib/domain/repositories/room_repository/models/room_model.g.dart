// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
      callerUser:
          MyUserModel.fromJson(json['callerUser'] as Map<String, dynamic>),
      calleeUser:
          MyUserModel.fromJson(json['calleeUser'] as Map<String, dynamic>),
      id: json['id'] as String,
      roomName: json['roomName'] as String,
      roomLanguage:
          LanguagesModel.fromJson(json['roomLanguage'] as Map<String, dynamic>),
      roomUsersList: (json['roomUsersList'] as List<dynamic>)
          .map((e) => MyUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      maxUserInRoom: (json['maxUserInRoom'] as num).toInt(),
      createTimeRoom: DateTime.parse(json['createTimeRoom'] as String),
    );

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
      'id': instance.id,
      'roomName': instance.roomName,
      'roomLanguage': instance.roomLanguage,
      'roomUsersList': instance.roomUsersList,
      'maxUserInRoom': instance.maxUserInRoom,
      'createTimeRoom': instance.createTimeRoom.toIso8601String(),
      'callerUser': instance.callerUser,
      'calleeUser': instance.calleeUser,
    };

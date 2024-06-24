// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
      id: json['id'] as String,
      roomName: json['roomName'] as String,
      roomLanguage: json['roomLanguage'] as String,
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
    };

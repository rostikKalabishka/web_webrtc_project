import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';

import '../../user_repository/models/my_user_model.dart';

part 'room_model.g.dart';

final DateTime now = DateTime.now();

@JsonSerializable()
class RoomModel extends Equatable {
  final String id;
  final String roomName;
  final LanguagesModel roomLanguage;
  final List<MyUserModel> roomUsersList;
  final int maxUserInRoom;
  final DateTime createTimeRoom;

  const RoomModel(
      {required this.id,
      required this.roomName,
      required this.roomLanguage,
      required this.roomUsersList,
      required this.maxUserInRoom,
      required this.createTimeRoom});
  @override
  List<Object?> get props => [id, roomLanguage, roomName, roomUsersList];

  // static const empty = RoomModel(
  //   id: '',
  //   roomName: '',
  //   roomLanguage: '',
  //   roomUsersList: [],
  //   maxUserInRoom: 0,
  //   createTimeRoom: DateTime(2023, 2, 26),
  // );

  RoomModel copyWith({
    String? id,
    String? roomName,
    LanguagesModel? roomLanguage,
    List<MyUserModel>? roomUsersList,
    int? maxUserInRoom,
    DateTime? createTimeRoom,
  }) {
    return RoomModel(
      id: id ?? this.id,
      roomName: roomName ?? this.roomName,
      roomLanguage: roomLanguage ?? this.roomLanguage,
      roomUsersList: roomUsersList ?? this.roomUsersList,
      maxUserInRoom: maxUserInRoom ?? this.maxUserInRoom,
      createTimeRoom: createTimeRoom ?? this.createTimeRoom,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'roomName': roomName,
        'roomLanguage': roomLanguage.toJson(),
        'roomUsersList': roomUsersList,
        'maxUserInRoom': maxUserInRoom,
        'createTimeRoom': createTimeRoom.toIso8601String(),
      };

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}

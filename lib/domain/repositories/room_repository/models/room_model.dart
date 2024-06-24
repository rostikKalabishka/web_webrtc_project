import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../user_repository/models/my_user_model.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel extends Equatable {
  final String id;
  final String roomName;
  final String roomLanguage;
  final List<MyUserModel> roomUsersList;

  const RoomModel(
      {required this.id,
      required this.roomName,
      required this.roomLanguage,
      required this.roomUsersList});
  @override
  List<Object?> get props => [id, roomLanguage, roomName, roomUsersList];

  static const empty =
      RoomModel(id: '', roomName: '', roomLanguage: '', roomUsersList: []);

  RoomModel copyWith({
    String? id,
    String? roomName,
    String? roomLanguage,
    List<MyUserModel>? roomUsersList,
  }) {
    return RoomModel(
      id: id ?? this.id,
      roomName: roomName ?? this.roomName,
      roomLanguage: roomLanguage ?? this.roomLanguage,
      roomUsersList: roomUsersList ?? this.roomUsersList,
    );
  }

  Map<String, dynamic> toJson() => _$RoomModelToJson(this);

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}

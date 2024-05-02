import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_user_model.g.dart';

@JsonSerializable()
class MyUserModel extends Equatable {
  final String id;
  final String email;
  final String username;
  final String userImage;

  const MyUserModel(
      {required this.id,
      required this.email,
      required this.username,
      required this.userImage});
  @override
  List<Object?> get props => [id, email, username, userImage];

  static const empty =
      MyUserModel(id: '', email: '', username: '', userImage: '');

  MyUserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? userImage,
  }) {
    return MyUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      userImage: userImage ?? this.userImage,
    );
  }

  Map<String, dynamic> toJson() => _$MyUserModelToJson(this);

  factory MyUserModel.fromJson(Map<String, dynamic> json) =>
      _$MyUserModelFromJson(json);
}

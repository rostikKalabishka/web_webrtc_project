import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'languages_model.g.dart';

@JsonSerializable()
class LanguagesModel extends Equatable {
  final String name;
  final String code;

  const LanguagesModel({required this.name, required this.code});

  @override
  List<Object?> get props => [name, code];

  Map<String, dynamic> toJson() => _$LanguagesModelToJson(this);

  factory LanguagesModel.fromJson(Map<String, dynamic> json) =>
      _$LanguagesModelFromJson(json);
}

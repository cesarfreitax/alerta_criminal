import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    required this.userId,
    required this.nickname,
    required this.name,
    required this.email,
    required this.cpf,
  });

  final String userId;
  final String nickname;
  final String name;
  final String email;
  final String cpf;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
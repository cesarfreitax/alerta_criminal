import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'crim_model.g.dart';

const uuid = Uuid();

@JsonSerializable()
class CrimModel {
  CrimModel({
    required this.userId,
    required this.title,
    required this.description,
    required this.lat,
    required this.lng,
    id,
    imageUrl,
  })  : id = id ?? uuid.v4(),
        imageUrl = imageUrl ?? "";

  final String id, title, description, userId;
  String imageUrl;
  final double lat;
  final double lng;

  factory CrimModel.fromJson(Map<String, dynamic> json) =>
      _$CrimModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrimModelToJson(this);
}

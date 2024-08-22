import 'package:json_annotation/json_annotation.dart';

part 'crim_entity.g.dart';

@JsonSerializable()
class CrimEntity {
  String id;
  String imageUrl;
  String title;
  String description;
  double lat;
  double lng;

  CrimEntity(
      this.id, this.imageUrl, this.title, this.description, this.lat, this.lng);

  factory CrimEntity.fromJson(Map<String, dynamic> json) =>
      _$CrimEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CrimEntityToJson(this);
}

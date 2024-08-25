import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'crime_model.g.dart';

const uuid = Uuid();

@JsonSerializable()
class CrimeModel {
  CrimeModel({
    required this.userId,
    required this.title,
    required this.description,
    required this.lat,
    required this.lng,
    required this.date,
    id,
    imageUrl,
  })  : id = id ?? uuid.v4(),
        imageUrl = imageUrl ?? "";

  final String id, title, description, userId;
  String imageUrl;
  final double lat;
  final double lng;
  final Timestamp date;

  factory CrimeModel.fromJson(Map<String, dynamic> json) =>
      _$CrimModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrimModelToJson(this);
}

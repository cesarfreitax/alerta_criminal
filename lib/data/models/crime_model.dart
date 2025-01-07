import 'package:alerta_criminal/data/models/crime_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'converter/custom_timestamp_converter.dart';

part 'crime_model.g.dart';

const uuid = Uuid();

@CustomTimestampConverter()
@JsonSerializable()
class CrimeModel {
  CrimeModel({
    required this.userId,
    required this.title,
    required this.description,
    required this.lat,
    required this.lng,
    required this.address,
    required this.date,
    required this.crimeTypeId,
    id,
    imageUrl,
  })  : id = id ?? uuid.v4(),
        imageUrl = imageUrl ?? "";

  final String id, title, description, userId;
  String imageUrl;
  final double lat;
  final double lng;
  final String address;
  final DateTime date;
  final int crimeTypeId;

  CrimeType getCrimeType() => crimeTypes.firstWhere( (crimeType) => crimeType.id == crimeTypeId);

  factory CrimeModel.fromJson(Map<String, dynamic> json) =>
      _$CrimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrimeModelToJson(this);
}

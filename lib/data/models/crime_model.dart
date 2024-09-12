import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

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
    required this.date,
    id,
    imageUrl,
  })  : id = id ?? uuid.v4(),
        imageUrl = imageUrl ?? "";

  final String id, title, description, userId;
  String imageUrl;
  final double lat;
  final double lng;
  final DateTime date;

  factory CrimeModel.fromJson(Map<String, dynamic> json) =>
      _$CrimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrimeModelToJson(this);
}

class CustomTimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const CustomTimestampConverter();

  @override
  DateTime fromJson(Timestamp json) => json.toDate();

  @override
  Timestamp toJson(DateTime object) => Timestamp.fromDate(object);
}

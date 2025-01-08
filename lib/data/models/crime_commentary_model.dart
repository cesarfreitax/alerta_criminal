import 'package:alerta_criminal/data/models/converter/custom_timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crime_commentary_model.g.dart';

@CustomTimestampConverter()
@JsonSerializable()
class CrimeCommentaryModel {

  final String? id;
  final String text;
  final String userId;
  final String cachedUsername;
  final DateTime date;
  final List<String> likes;

  CrimeCommentaryModel({
    this.id,
    required this.likes,
    required this.text,
    required this.userId,
    required this.cachedUsername,
    required this.date
  });

  CrimeCommentaryModel copyWith({
    String? id,
    String? text,
    String? userId,
    String? cachedUsername,
    DateTime? date,
    List<String>? likes,
  }) {
    return CrimeCommentaryModel(
      id: id ?? this.id,
      text: text ?? this.text,
      userId: userId ?? this.userId,
      cachedUsername: cachedUsername ?? this.cachedUsername,
      date: date ?? this.date,
      likes: likes ?? this.likes,
    );
  }

  factory CrimeCommentaryModel.fromJson(Map<String, dynamic> json) => _$CrimeCommentaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrimeCommentaryModelToJson(this);
}
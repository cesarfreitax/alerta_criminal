// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crime_commentary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrimeCommentaryModel _$CrimeCommentaryModelFromJson(
        Map<String, dynamic> json) =>
    CrimeCommentaryModel(
      id: json['id'] as String?,
      likes: (json['likes'] as List<dynamic>).map((e) => e as String).toList(),
      text: json['text'] as String,
      userId: json['userId'] as String,
      cachedUsername: json['cachedUsername'] as String,
      date:
          const CustomTimestampConverter().fromJson(json['date'] as Timestamp),
    );

Map<String, dynamic> _$CrimeCommentaryModelToJson(
        CrimeCommentaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'userId': instance.userId,
      'cachedUsername': instance.cachedUsername,
      'date': const CustomTimestampConverter().toJson(instance.date),
      'likes': instance.likes,
    };

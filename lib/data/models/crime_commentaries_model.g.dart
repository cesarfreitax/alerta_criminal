// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crime_commentaries_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrimeCommentariesModel _$CrimeCommentariesModelFromJson(
        Map<String, dynamic> json) =>
    CrimeCommentariesModel(
      json['id'] as String,
      crimeId: json['crimeId'] as String,
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CrimeCommentaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CrimeCommentariesModelToJson(
        CrimeCommentariesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'crimeId': instance.crimeId,
      'comments': instance.comments.map((e) => e.toJson()).toList(),
    };

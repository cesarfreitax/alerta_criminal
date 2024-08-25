// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrimeModel _$CrimModelFromJson(Map<String, dynamic> json) => CrimeModel(
      title: json['title'] as String,
      description: json['description'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      id: json['id'],
      imageUrl: json['imageUrl'],
      userId: json['userId'] as String,
      date: json['date'] as Timestamp
    );

Map<String, dynamic> _$CrimModelToJson(CrimeModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'lat': instance.lat,
      'lng': instance.lng,
      'userId': instance.userId,
      'date': instance.date
    };

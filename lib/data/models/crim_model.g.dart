// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crim_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrimModel _$CrimModelFromJson(Map<String, dynamic> json) => CrimModel(
      title: json['title'] as String,
      description: json['description'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      id: json['id'],
      imageUrl: json['imageUrl'],
      userId: json['userId'] as String
    );

Map<String, dynamic> _$CrimModelToJson(CrimModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'lat': instance.lat,
      'lng': instance.lng,
      'userId': instance.userId
    };

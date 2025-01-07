// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrimeModel _$CrimeModelFromJson(Map<String, dynamic> json) => CrimeModel(
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String,
      date:
          const CustomTimestampConverter().fromJson(json['date'] as Timestamp),
      crimeTypeId: (json['crimeTypeId'] as num).toInt(),
      id: json['id'],
      imageUrl: json['imageUrl'],
    );

Map<String, dynamic> _$CrimeModelToJson(CrimeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'userId': instance.userId,
      'imageUrl': instance.imageUrl,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'date': const CustomTimestampConverter().toJson(instance.date),
      'crimeTypeId': instance.crimeTypeId,
    };

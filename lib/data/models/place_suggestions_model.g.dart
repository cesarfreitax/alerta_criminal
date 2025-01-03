// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_suggestions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceSuggestionModel _$PlaceSuggestionModelFromJson(
        Map<String, dynamic> json) =>
    PlaceSuggestionModel(
      description: json['description'] as String,
    );

Map<String, dynamic> _$PlaceSuggestionModelToJson(
        PlaceSuggestionModel instance) =>
    <String, dynamic>{
      'description': instance.description,
    };

PlaceSuggestionsModel _$PlaceSuggestionsModelFromJson(
        Map<String, dynamic> json) =>
    PlaceSuggestionsModel(
      predictions: (json['predictions'] as List<dynamic>)
          .map((e) => PlaceSuggestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlaceSuggestionsModelToJson(
        PlaceSuggestionsModel instance) =>
    <String, dynamic>{
      'predictions': instance.predictions,
    };

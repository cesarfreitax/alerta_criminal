import 'package:json_annotation/json_annotation.dart';

part 'place_suggestions_model.g.dart';

@JsonSerializable()
class PlaceSuggestionModel {
  final String description;

  PlaceSuggestionModel({
    required this.description,
  });

  factory PlaceSuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceSuggestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceSuggestionModelToJson(this);
}

@JsonSerializable()
class PlaceSuggestionsModel {
  final List<PlaceSuggestionModel> predictions;

  PlaceSuggestionsModel({
    required this.predictions,
  });

  factory PlaceSuggestionsModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceSuggestionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceSuggestionsModelToJson(this);
}
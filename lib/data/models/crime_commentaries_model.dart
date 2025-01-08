import 'package:json_annotation/json_annotation.dart';

import 'converter/custom_timestamp_converter.dart';
import 'crime_commentary_model.dart';

part 'crime_commentaries_model.g.dart';

@CustomTimestampConverter()
@JsonSerializable(explicitToJson: true)
class CrimeCommentariesModel {
  CrimeCommentariesModel({
    this.id,
    required this.comments,
  });

  final String? id;
  final List<CrimeCommentaryModel> comments;

  factory CrimeCommentariesModel.fromJson(Map<String, dynamic> json) => _$CrimeCommentariesModelFromJson(json);

  Map<String, dynamic> toJson() => _$CrimeCommentariesModelToJson(this);
}

import 'package:alerta_criminal/data/models/crime_commentaries_model.dart';
import 'package:alerta_criminal/data/models/crime_commentary_model.dart';

abstract class CrimeCommentariesRepository {
  Future<CrimeCommentariesModel?> createOrUpdateCrimeCommentaries(String crimeId, CrimeCommentaryModel newComment);

  Future<CrimeCommentariesModel?> getCrimeCommentaries(String crimeId);
}
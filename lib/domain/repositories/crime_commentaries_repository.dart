import 'package:alerta_criminal/data/models/crime_commentary_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CrimeCommentariesRepository {
  CollectionReference<CrimeCommentaryModel> getCommentariesCollectionReference(String crimeId);
  Future<CrimeCommentaryModel?> addCommentary(String crimeId, CrimeCommentaryModel commentary);
  Future<List<CrimeCommentaryModel>> getCommentaries(String crimeId);
  Future<void> updateCommentary(String crimeId, String commentaryId, Map<String, dynamic> updates);
  Future<void> toggleLikeOnCommentary(String crimeId, String commentaryId, String userId, bool alreadyLiked);
}
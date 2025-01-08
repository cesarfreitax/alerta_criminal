import 'package:alerta_criminal/data/models/crime_commentary_model.dart';
import 'package:alerta_criminal/domain/repositories/crime_commentaries_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrimeCommentariesUseCase {
  final CrimeCommentariesRepository repository;
  final FirebaseFirestore firebaseFirestore;

  CrimeCommentariesUseCase(this.repository, this.firebaseFirestore);

  Future<void> toggleLikeOnCommentary(String crimeId, String commentaryId, String userId) async => repository.toggleLikeOnCommentary(crimeId, commentaryId, userId);
  CollectionReference<CrimeCommentaryModel> getCommentariesCollectionReference(String crimeId) => repository.getCommentariesCollectionReference(crimeId);
  Future<List<CrimeCommentaryModel>> getCommentaries(String crimeId) async => repository.getCommentaries(crimeId);
  Future<CrimeCommentaryModel?> addCommentary(String crimeId, CrimeCommentaryModel commentary) async => repository.addCommentary(crimeId, commentary);
}

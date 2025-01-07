import 'package:alerta_criminal/data/models/crime_commentaries_model.dart';
import 'package:alerta_criminal/data/models/crime_commentary_model.dart';
import 'package:alerta_criminal/domain/repositories/crime_commentaries_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrimeCommentariesUseCase {
  final CrimeCommentariesRepository repository;
  final FirebaseFirestore firebaseFirestore;

  CrimeCommentariesUseCase(this.repository, this.firebaseFirestore);

  Future<CrimeCommentariesModel?> createOrUpdateCrimeCommentaries(
          String crimeId, CrimeCommentaryModel newComment) async =>
      await repository.createOrUpdateCrimeCommentaries(crimeId, newComment);

  Future<CrimeCommentariesModel?> getCrimeCommentaries(String crimeId) async => repository.getCrimeCommentaries(crimeId);
}

import 'package:alerta_criminal/core/util/constants.dart';
import 'package:alerta_criminal/core/util/log_util.dart';
import 'package:alerta_criminal/data/models/crime_commentary_model.dart';
import 'package:alerta_criminal/domain/repositories/crime_commentaries_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrimeCommentariesRepositoryImpl extends CrimeCommentariesRepository {
  final FirebaseFirestore firebaseFirestoreInstance;

  CrimeCommentariesRepositoryImpl(this.firebaseFirestoreInstance);

  CollectionReference<Map<String, dynamic>> getCollectionRef() =>
      firebaseFirestoreInstance.collection(Constants.crimeCommentariesCollectionName);

  Future<QuerySnapshot<Map<String, dynamic>>> getQuerySnapshot(String id) async {
    final collectionRef = getCollectionRef();
    final querySnapshot = await collectionRef.where(Constants.crimeCommentariesCrimeId, isEqualTo: id).get();
    return querySnapshot;
  }

  @override
  Future<void> toggleLikeOnCommentary(String crimeId, String commentaryId, String userId, bool alreadyLiked) async {
    final update = {
      'likes': alreadyLiked ? FieldValue.arrayRemove([userId]) : FieldValue.arrayUnion([userId])
    };
    await updateCommentary(crimeId, commentaryId, update);
  }

  @override
  CollectionReference<CrimeCommentaryModel> getCommentariesCollectionReference(String crimeId) {
    final crimeCommentariesDocRef = firebaseFirestoreInstance
        .collection(Constants.crimeCommentariesCollectionName)
        .doc(crimeId)
        .collection(Constants.crimeCommentariesSubcollectionName)
        .withConverter<CrimeCommentaryModel>(
            fromFirestore: (snapshots, _) => CrimeCommentaryModel.fromJson(snapshots.data()!),
            toFirestore: (commentary, _) => commentary.toJson());
    return crimeCommentariesDocRef;
  }

  @override
  Future<CrimeCommentaryModel?> addCommentary(String crimeId, CrimeCommentaryModel commentary) async {
    late final CrimeCommentaryModel? commentaryCreated;
    final crimeCommentariesCollection = getCommentariesCollectionReference(crimeId);

    try {
      final commentaryDocRef = crimeCommentariesCollection.doc();
      final generatedId = commentaryDocRef.id;
      final newCommentary = commentary.copyWith(id: generatedId);
      await commentaryDocRef.set(newCommentary);
      final commentarySnapshot = await commentaryDocRef.get();
      commentaryCreated = commentarySnapshot.data();
    } catch (e) {
      printDebug("Error when trying to add a new crime commentary: $e");
    }

    return commentaryCreated;
  }

  @override
  Future<List<CrimeCommentaryModel>> getCommentaries(String crimeId) async {
    late final QuerySnapshot<CrimeCommentaryModel> commentariesQuerySnapshot;
    final commentariesCollectionReference = getCommentariesCollectionReference(crimeId);
    try {
      commentariesQuerySnapshot = await commentariesCollectionReference.get();
    } catch (e) {
      printDebug("Error when trying to get crime commentaries: $e");
    }
    final commentaries = commentariesQuerySnapshot.docs.map((doc) => doc.data()).toList();
    return commentaries;
  }

  @override
  Future<void> updateCommentary(String crimeId, String commentaryId, Map<String, dynamic> updates) async {
    final commentariesCollectionReference = getCommentariesCollectionReference(crimeId);
    try {
      final commentaryDocRef = commentariesCollectionReference.doc(commentaryId);
      await commentaryDocRef.update(updates);
    } catch (e) {
      printDebug("Error when trying to update a crime commentary: $e");
    }
  }
}

import 'package:alerta_criminal/core/util/constants.dart';
import 'package:alerta_criminal/core/util/log_util.dart';
import 'package:alerta_criminal/data/models/crime_commentaries_model.dart';
import 'package:alerta_criminal/data/models/crime_commentary_model.dart';
import 'package:alerta_criminal/domain/repositories/crime_commentaries_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrimeCommentariesRepositoryImpl extends CrimeCommentariesRepository {
  final FirebaseFirestore firebaseFirestoreInstance;

  CrimeCommentariesRepositoryImpl(this.firebaseFirestoreInstance);

  @override
  Future<CrimeCommentariesModel?> createOrUpdateCrimeCommentaries(String crimeId, CrimeCommentaryModel newComment) async {

    try {
      final querySnapshot = await getQuerySnapshot(crimeId);

      DocumentReference? docRef;

      if (querySnapshot.docs.isNotEmpty) {
        // Update case in case of existent document
        docRef = querySnapshot.docs.first.reference;

        await docRef.update({
          Constants.crimeCommentariesComments: FieldValue.arrayUnion([newComment.toJson()])
        });
      } else {
        // Create new document and add the commentary in case of inexistent document
        docRef = getCollectionRef().doc();

        final newCrimeCommentaries = CrimeCommentariesModel(
          docRef.id,
          crimeId: crimeId,
          comments: [newComment],
        );

        await docRef.set(newCrimeCommentaries.toJson());
      }

      final doc = await docRef.get();

      return CrimeCommentariesModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      printDebug(e.toString());
    }

    return null;
  }

  @override
  Future<CrimeCommentariesModel?> getCrimeCommentaries(String crimeId) async {
    try {
      final querySnapshot = await getQuerySnapshot(crimeId);

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final docData = querySnapshot.docs.first.data();
      return CrimeCommentariesModel.fromJson(docData);
    } catch (e) {
      printDebug("Error fetching crime commentaries': ${e.toString()}");
      return null;
    }
  }

  CollectionReference<Map<String, dynamic>> getCollectionRef() => firebaseFirestoreInstance.collection(Constants.crimeCommentariesCollectionName);

  Future<QuerySnapshot<Map<String, dynamic>>> getQuerySnapshot(String id) async {
    final collectionRef = getCollectionRef();
    final querySnapshot = await collectionRef.where(Constants.crimeCommentariesCrimeId, isEqualTo: id).get();
    return querySnapshot;
  }
}

import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:alerta_criminal/domain/repositories/crim_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrimUseCase {
  final CrimRepository repository;
  final FirebaseFirestore firebaseFirestoreInstance;

  CrimUseCase(this.repository, this.firebaseFirestoreInstance);

  Future<void> add(CrimeModel crim) async {
    await repository.add(crim);
  }

  CollectionReference<CrimeModel> getCrimsRef() {
    return repository.getCrimsRef();
  }
}
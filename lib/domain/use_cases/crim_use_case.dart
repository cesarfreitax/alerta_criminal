import 'package:alerta_criminal/data/models/crim_model.dart';
import 'package:alerta_criminal/domain/repositories/crim_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrimUseCase {
  final CrimRepository repository;
  final FirebaseFirestore firebaseFirestoreInstance;

  CrimUseCase(this.repository, this.firebaseFirestoreInstance);

  Future<void> add(CrimModel crim) async {
    await repository.add(crim);
  }

  CollectionReference<CrimModel> getCrimsRef() {
    return repository.getCrimsRef();
  }
}
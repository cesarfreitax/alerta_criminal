import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/utils/constants.dart';
import 'package:alerta_criminal/data/models/crim_model.dart';
import 'package:alerta_criminal/domain/repositories/crim_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrimRepositoryImpl extends CrimRepository {
  final FirebaseFirestore firebaseFirestoreInstance;

  CrimRepositoryImpl(this.firebaseFirestoreInstance);

  @override
  Future<void> add(CrimModel crim) async {
    final crimsRef = DependencyInjection.crimUseCase.getCrimsRef();
    crimsRef.add(crim);
  }

  @override
  CollectionReference<CrimModel> getCrimsRef() {
    final crimsRef =
    firebaseFirestoreInstance.collection(Constants.crimsCollectionName).withConverter<CrimModel>(
      fromFirestore: (snapshots, _) => CrimModel.fromJson(snapshots.data()!),
      toFirestore: (crim, _) => crim.toJson(),
    );
    return crimsRef;
  }

}
import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/utils/constants.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:alerta_criminal/domain/repositories/crim_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrimRepositoryImpl extends CrimRepository {
  final FirebaseFirestore firebaseFirestoreInstance;

  CrimRepositoryImpl(this.firebaseFirestoreInstance);

  @override
  Future<void> add(CrimeModel crim) async {
    final crimsRef = DependencyInjection.crimUseCase.getCrimsRef();
    crimsRef.add(crim);
  }

  @override
  CollectionReference<CrimeModel> getCrimsRef() {
    final crimsRef =
    firebaseFirestoreInstance.collection(Constants.crimsCollectionName).withConverter<CrimeModel>(
      fromFirestore: (snapshots, _) => CrimeModel.fromJson(snapshots.data()!),
      toFirestore: (crim, _) => crim.toJson(),
    );
    return crimsRef;
  }

}
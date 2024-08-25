import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CrimRepository {
  Future<void> add(CrimeModel crim);

  CollectionReference<CrimeModel> getCrimsRef();
}
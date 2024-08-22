import 'package:alerta_criminal/data/models/crim_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CrimRepository {
  Future<void> add(CrimModel crim);

  CollectionReference<CrimModel> getCrimsRef();
}
import 'dart:io';

import 'package:alerta_criminal/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserDataRepository {
  Future<String> saveCrimImage(File image, String crimId);
  CollectionReference<Map<String, dynamic>> getUserRef();
  Future<void> saveUserData(UserModel userData);
  Future<UserModel> getUserData(String userId);
}
import 'dart:io';
import 'dart:ui';

import 'package:alerta_criminal/data/models/user_model.dart';
import 'package:alerta_criminal/domain/repositories/user_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserDataUseCase {
  final UserDataRepository repository;

  UserDataUseCase(this.repository);

  CollectionReference<Map<String, dynamic>> getUserRef() {
    return repository.getUserRef();
  }

  Future<String> saveCrimImage(File image, String crimeId) async {
   return await repository.saveCrimImage(image, crimeId);
  }

  Future<void> saveUserData(UserModel userData) async {
    return await repository.saveUserData(userData);
  }

  Future<UserModel> getUserData(String userId) async {
    return await repository.getUserData(userId);
  }

  void setPreferredLanguage(Locale locale) async => repository.setPreferredLanguage(locale);

  Locale? getPreferredLanguage() => repository.getPreferredLanguage();
}
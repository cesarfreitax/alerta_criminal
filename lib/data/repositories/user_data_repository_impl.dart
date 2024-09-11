import 'dart:io';
import 'dart:ui';

import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/utils/constants.dart';
import 'package:alerta_criminal/core/utils/log_util.dart';
import 'package:alerta_criminal/data/models/user_model.dart';
import 'package:alerta_criminal/domain/repositories/user_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

const crimImagesTable = 'crim_images';

class UserDataRepositoryImpl implements UserDataRepository {
  @override
  Future<String> saveCrimImage(File image, String crimId) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(crimImagesTable)
        .child(getImageName(crimId));

    try {
      await ref.putFile(File(image.path));
    } catch (e) {
      printDebug(e.toString());
    }

    final imageDownloadUrl = await ref.getDownloadURL();
    return imageDownloadUrl;
  }

  String getImageName(String crimId) => '/$crimId.jpg';

  @override
  CollectionReference<Map<String, dynamic>> getUserRef() {
    return firebaseFirestoreInstance.collection(Constants.usersCollectionName);
  }

  @override
  Future<void> saveUserData(UserModel userData) async {
    await getUserRef().doc(userData.userId).set(userData.toJson());
  }

  @override
  Future<UserModel> getUserData(String userId) async {
    final userData =  await getUserRef().doc(userId).get();
    UserModel? user;
    try {
      user = UserModel.fromJson(userData.data()!);
    } catch (e) {
      final error = e;
      printDebug(error.toString());
    }
    return user!;
  }

  @override
  void setPreferredLanguage(Locale locale) {
    localStorage.setItem(Constants.preferredLanguage, locale.toString());
  }

  @override
  Locale? getPreferredLanguage() {
    final preferredLanguage = localStorage.getItem(Constants.preferredLanguage);

    if (preferredLanguage == null) return null;

    return Locale.fromSubtags(languageCode: preferredLanguage.split('_')[0], countryCode: preferredLanguage.split('_')[1]);
  }
}
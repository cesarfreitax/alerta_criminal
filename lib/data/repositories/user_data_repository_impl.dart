import 'dart:io';

import 'package:alerta_criminal/core/utils/log_util.dart';
import 'package:alerta_criminal/domain/repositories/user_data_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
}
import 'dart:io';

import 'package:alerta_criminal/domain/repositories/user_data_repository.dart';

class UserDataUseCase {
  final UserDataRepository repository;

  UserDataUseCase(this.repository);

  Future<void> saveCrimImage(File image, String userId) async {
    await repository.saveCrimImage(image, userId);
  }
}
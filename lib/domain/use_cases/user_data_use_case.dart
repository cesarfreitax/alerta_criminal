import 'dart:io';

import 'package:alerta_criminal/domain/repositories/user_data_repository.dart';

class UserDataUseCase {
  final UserDataRepository repository;

  UserDataUseCase(this.repository);

  Future<String> saveCrimImage(File image, String userId) async {
   return await repository.saveCrimImage(image, userId);
  }
}
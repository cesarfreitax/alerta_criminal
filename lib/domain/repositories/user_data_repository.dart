import 'dart:io';

abstract class UserDataRepository {
  Future<String> saveCrimImage(File image, String crimId);
}
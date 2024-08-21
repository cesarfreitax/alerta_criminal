import 'package:alerta_criminal/core/services/string_service.dart';
import 'package:flutter/cupertino.dart';

class StringServiceFactory {
  static StringService create(BuildContext context) {
    return StringService(context);
  }
}
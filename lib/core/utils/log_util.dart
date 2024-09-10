import 'dart:developer';

import 'package:flutter/foundation.dart';

void printDebug(String message) {
  if (kDebugMode) {
    log(message);
  }  
}
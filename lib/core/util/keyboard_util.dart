import 'package:flutter/cupertino.dart';

void closeKeyboard(BuildContext context) {
  final f = FocusScope.of(context);

  if (!f.hasPrimaryFocus) {
    f.unfocus();
  }
}
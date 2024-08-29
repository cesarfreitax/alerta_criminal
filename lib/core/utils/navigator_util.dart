import 'package:flutter/material.dart';

void navigate(BuildContext context, bool clearBackStack, Widget screen) {
  if (clearBackStack) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
            (Route route) => false
    );
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen)
    );
  }
  
}

import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/providers/user_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/string_util.dart';

class ChangeNicknameScreen extends ConsumerWidget {
  const ChangeNicknameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(getStrings(context).changeNickname),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                firebaseAuthInstance.currentUser!.updateDisplayName(nicknameController.text);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: TextField(
            controller: nicknameController,
            decoration: InputDecoration(
              labelText: getStrings(context).nickname,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              prefixIcon: const Icon(Icons.person),
            )),
      ),
    );
  }
}

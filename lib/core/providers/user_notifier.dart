import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:alerta_criminal/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<User?> {
  final FirebaseAuth _auth;

  UserNotifier(this._auth) : super(null) {
    _auth.authStateChanges().listen((user) {
      state = user;
    });
  }

  @override
  void dispose() {
    // Cancel the subscription when the notifier is disposed to avoid memory leaks.
    _auth.authStateChanges().listen(null).cancel();
    super.dispose();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>(
      (ref) => UserNotifier(firebaseAuthInstance),
);

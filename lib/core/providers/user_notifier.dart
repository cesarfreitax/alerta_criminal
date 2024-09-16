import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  final FirebaseAuth _auth;

  UserNotifier(this._auth) : super(null) {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        getUserDataInfo(user.uid);
      } else {
        state = null;
      }
    });
  }

  void getUserDataInfo(String userId) async => state = await DependencyInjection.userDataUseCase.getUserData(userId);

  @override
  void dispose() {
    // Cancel the subscription when the notifier is disposed to avoid memory leaks.
    _auth.authStateChanges().listen(null).cancel();
    super.dispose();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>(
      (ref) => UserNotifier(firebaseAuthInstance),
);

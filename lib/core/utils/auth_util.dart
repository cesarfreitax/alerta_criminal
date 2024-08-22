import 'package:firebase_auth/firebase_auth.dart';

final _firebaseAuthInstance = FirebaseAuth.instance;

User? getCurrentUser() {
  return _firebaseAuthInstance.currentUser;
}
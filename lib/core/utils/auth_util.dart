import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? getCurrentUser() => firebaseAuthInstance.currentUser;
void logout() => firebaseAuthInstance.signOut();

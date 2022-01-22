import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_taking_app/services/firebase_auth.dart';

class UserAuthentication {
  final FirebaseAuth _firebaseAuthentication =
      FirebaseAuthentication.firebaseAuthInstance();

  // Register new user using FirebaseAuth
  Future<bool> registerUser(
      {required String email, required String password}) async {
    bool isUserRegistered = false;
    try {
      // Register new user
      final newUser =
          await _firebaseAuthentication.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (newUser != null) {
        isUserRegistered = true;
      }
    } on FirebaseException catch (e) {}
    return isUserRegistered;
  }
}

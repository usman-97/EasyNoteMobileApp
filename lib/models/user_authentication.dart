import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_taking_app/services/firebase_auth.dart';

class UserControl {
  final FirebaseAuth _firebaseAuthentication =
      FirebaseAuthentication.firebaseAuthInstance();

  Future<bool> registerUser(
      {required String email, required String password}) async {
    bool isUserRegistered = false;
    try {
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

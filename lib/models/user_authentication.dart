import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_taking_app/services/firebase_auth.dart';

class UserAuthentication {
  final FirebaseAuth _firebaseAuthentication =
      FirebaseAuthentication.firebaseAuthInstance();
  User? _currentUser;

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

      // user = getCurrentUser();
      if (newUser != null) {
        isUserRegistered = true;
        signInUser(email, password);
      }
    } on FirebaseException catch (e) {}
    return isUserRegistered;
  }

  Future<bool> signInUser(String email, String password) async {
    bool isUserSignedIn = false;
    try {
      UserCredential user = await _firebaseAuthentication
          .signInWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        isUserSignedIn = true;
        _currentUser = _firebaseAuthentication.currentUser;
      }
    } on FirebaseAuthentication catch (e) {}
    return isUserSignedIn;
  }

  // Future<bool> isUserEmailVerified(String email) async {
  //   User? user = _firebaseAuthentication.currentUser;
  //   await user?.reload();
  //   if (user != null && !user.emailVerified) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
  //
  // User? getCurrentUser() {
  //   try {
  //     final User? user = _firebaseAuthentication.currentUser;
  //     if (user != null) {
  //       return user;
  //     }
  //   } catch (e) {}
  // }
}

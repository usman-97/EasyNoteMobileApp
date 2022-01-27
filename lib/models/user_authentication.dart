import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_taking_app/services/firebase_auth.dart';

class UserAuthentication {
  final FirebaseAuth _firebaseAuthentication =
      FirebaseAuthentication.firebaseAuthInstance();
  // User? _currentUser;

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
        // try {
        //   User? currentUser = _firebaseAuthentication.currentUser;
        //   if (_currentUser != null) {
        //     _currentUser = _currentUser;
        //   }
        // } catch (e) {}
      }
    } on FirebaseAuthentication catch (e) {}
    return isUserSignedIn;
  }

  Future<bool> isUserEmailVerified(String email) async {
    bool isEmailVerified = false;
    User? currentUser = getCurrentUser();
    await currentUser?.reload();
    if (currentUser != null) {
      if (currentUser.emailVerified) {
        isEmailVerified = true;
      }
    }
    return isEmailVerified;
  }

  Future<void> sendEmailVerification(String email) async {
    bool isUserEmailVerified = await this.isUserEmailVerified(email);
    User? currentUser = getCurrentUser();
    if (!isUserEmailVerified) {
      currentUser?.sendEmailVerification();
    }
  }

  User? getCurrentUser() {
    // return _currentUser;
    try {
      User? currentUser = _firebaseAuthentication.currentUser;
      if (currentUser != null) {
        return currentUser;
      }
    } catch (e) {}
  }

  String getCurrentUserEmail() {
    var currentUser = getCurrentUser();
    String userEmail = '';
    if (currentUser != null) {
      userEmail = currentUser.email!;
    }
    return userEmail;
  }
}

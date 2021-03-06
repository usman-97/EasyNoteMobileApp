import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_taking_app/services/firebase_auth.dart';

class UserAuthentication {
  final FirebaseAuth _firebaseAuthentication =
      FirebaseAuthentication.firebaseAuthInstance();
  String _userErrorCode = '', _error = '';

  get error => _error;

  /// Register new user using FirebaseAuth using
  /// user [email] and [password]
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

      // If user is successfully added to database
      if (newUser != null) {
        isUserRegistered = true;
        signInUser(email, password);
      }
    } on FirebaseException catch (e) {
      _userErrorCode = e.message!;
    }
    return isUserRegistered;
  }

  /// Sign in user to their created account by using their login credentials
  /// using [email] and [password]
  Future<bool> signInUser(String email, String password) async {
    bool isUserSignedIn = false;
    try {
      // Sign in user
      UserCredential user = await _firebaseAuthentication
          .signInWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        isUserSignedIn = true;
      }
    } on FirebaseException catch (e) {
      // Sign in error message
      _userErrorCode = e.message!;
    }
    return isUserSignedIn;
  }

  /// Check if user email has been verified before giving them
  ///  full access to their account
  Future<bool> isUserEmailVerified() async {
    bool isEmailVerified = false;
    User? currentUser = getCurrentUser(); // Current logged in user
    await currentUser?.reload(); // reload user
    if (currentUser != null) {
      if (currentUser.emailVerified) {
        isEmailVerified = true;
      }
    }
    return isEmailVerified;
  }

  /// Send email verification to user's email
  Future<void> sendEmailVerification() async {
    bool isUserEmailVerified = await this.isUserEmailVerified();
    User? currentUser = getCurrentUser();
    if (!isUserEmailVerified) {
      currentUser?.sendEmailVerification();
    }
  }

  /// Get current User object
  User? getCurrentUser() {
    // return _currentUser;
    try {
      User? currentUser = _firebaseAuthentication.currentUser;
      if (currentUser != null) {
        return currentUser;
      }
    } catch (e) {
      _error = e.toString();
    }
    return null;
  }

  /// Get current logged in user's email
  String getCurrentUserEmail() {
    var currentUser = getCurrentUser();
    String userEmail = '';
    if (currentUser != null) {
      userEmail = currentUser.email!;
    }
    return userEmail;
  }

  /// Sign out current signed in user
  void signOutUser() {
    try {
      _firebaseAuthentication.signOut();
    } on FirebaseException catch (e) {
      _error = e.code;
    }
  }

  /// Get user authentication error code
  String getUserErrorCode() {
    return _userErrorCode;
  }
}

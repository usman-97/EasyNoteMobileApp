import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final Stream<User?> _userChange = _firebaseAuth.userChanges();

  FirebaseAuthentication._();

  static FirebaseAuth firebaseAuthInstance() {
    return _firebaseAuth;
  }

  static Stream<User?> get userChange => _userChange;
}

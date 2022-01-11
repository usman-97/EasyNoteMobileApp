import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  FirebaseAuthentication._();

  static FirebaseAuth firebaseAuthInstance() {
    return FirebaseAuth.instance;
  }
}

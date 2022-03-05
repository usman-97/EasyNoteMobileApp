// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDt-WA71BNioXbctNq_enl7HcmKl0X9x00',
    appId: '1:1049770163620:android:176d7f70faf1a924559531',
    messagingSenderId: '1049770163620',
    projectId: 'easynote-40806',
    storageBucket: 'easynote-40806.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-k4ljHusGr3e-Wifh4GoG2CypGslfZSE',
    appId: '1:1049770163620:ios:b5c9eb8ff61c91bc559531',
    messagingSenderId: '1049770163620',
    projectId: 'easynote-40806',
    storageBucket: 'easynote-40806.appspot.com',
    iosClientId: '1049770163620-5ep2fpns23sgn32loq058taaj2pn803c.apps.googleusercontent.com',
    iosBundleId: 'com.usk.easynote',
  );
}
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/utilities/navigation.dart';

class VerificationScreenViewModel {
  final UserAuthentication _userAuthentication = UserAuthentication();

  String getCurrentUserEmail() {
    return _userAuthentication.getCurrentUserEmail();
  }

  Future<void> sendUserEmailVerification() async {
    await _userAuthentication.sendEmailVerification();
  }

  void checkUserEmailVerification(BuildContext context) {
    const Duration oneSec = Duration(seconds: 3);
    Timer.periodic(oneSec, (timer) async {
      bool isUserEmailVerified =
          await _userAuthentication.isUserEmailVerified();
      if (isUserEmailVerified) {
        Navigation.navigateToHome(context);
        timer.cancel();
      }
    });
  }
}

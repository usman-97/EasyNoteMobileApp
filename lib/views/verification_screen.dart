import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/Verification_screen_view_model.dart';
import 'package:note_taking_app/viewModels/user_view_model.dart';

class VerificationScreen extends StatefulWidget {
  static const String id = 'verification_screen';

  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final VerificationScreenViewModel _verificationScreenViewModel =
      VerificationScreenViewModel();
  final UserViewModel _userViewModel = UserViewModel();

  // @override
  // void initState() async {
  //   super.initState();
  //   await _verificationScreenViewModel.sendUserEmailVerification();
  // }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _verificationScreenViewModel.checkUserEmailVerification(context);
    });
    return Scaffold(
      backgroundColor: kLightPrimaryColour,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: kPrimaryColour,
              height: kTopContainerHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Hello User'),
                    TextButton(
                      onPressed: () {
                        _userViewModel.signOutUser();
                        Navigation.navigateToLogin(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: kLightPrimaryColour,
                      ),
                      child: const Icon(Icons.exit_to_app_outlined),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  color: kPrimaryColour,
                  height: 230.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          'Verification email has been sent to ${_verificationScreenViewModel.getCurrentUserEmail()}. Please verify your email to complete the registration. \n\nIf you cannot find verification email in your inbox then please kindly check the junk/spam folder.',
                          style: const TextStyle(
                              color: kTextIconColour, fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

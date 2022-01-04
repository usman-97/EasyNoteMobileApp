import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkPrimaryColour,
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(
              child: Text(
                'EasyNote',
                style: kMainHeadingStyle,
              ),
            ),
            const SizedBox(
              height: 20.0,
              child: Divider(
                thickness: 2.0,
                color: kTextIconColour,
                indent: 50.0,
                endIndent: 50.0,
              ),
            ),
            const Center(
              child: Text(
                'Capture your ideas',
                style: kMainHeadingSubtitle,
              ),
            ),
            Center(
              child: SizedBox(
                width: 350.0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: kTextFieldInputDecoration.copyWith(
                      fillColor: kTextIconColour,
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 350.0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: kTextFieldInputDecoration.copyWith(
                      fillColor: kTextIconColour,
                      hintText: 'Password',
                    ),
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

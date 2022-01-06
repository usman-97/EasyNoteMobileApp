import 'package:flutter/material.dart';
import 'package:note_taking_app/components/link_button.dart';
import 'package:note_taking_app/components/round_button.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/register_screen_view_model.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterScreenViewModel registerScreenViewModel =
      RegisterScreenViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkPrimaryColour,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'EasyNote',
              style: kMainHeadingStyle.copyWith(fontSize: 40.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10.0,
              child: Divider(
                thickness: 2.0,
                color: kTextIconColour,
                indent: 70.0,
                endIndent: 70.0,
              ),
            ),
            Text(
              'Capture your ideas',
              style: kMainHeadingSubtitle.copyWith(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            Center(
              child: SizedBox(
                width: 350.0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
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
                      hintText: 'Confirm Password',
                    ),
                  ),
                ),
              ),
            ),
            const Center(
              child: RoundButton(
                label: 'Register',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Already registered?',
                  style: TextStyle(
                    color: kTextIconColour,
                    fontSize: 18.0,
                  ),
                ),
                LinkButton(
                  text: 'Login here',
                  onPressed: () {
                    registerScreenViewModel.navigateToLoginScreen(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

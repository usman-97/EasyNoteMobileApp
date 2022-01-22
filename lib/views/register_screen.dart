import 'package:flutter/material.dart';
import 'package:note_taking_app/components/link_button.dart';
import 'package:note_taking_app/components/round_button.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/register_screen_view_model.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterScreenViewModel _registerScreenViewModel =
      RegisterScreenViewModel();
  String _registrationError = '',
      _email = '',
      _password = '',
      _confirmPassword = '';

  // void updateError() {
  //   setState(() {
  //     _registrationError = _registerScreenViewModel.getRegistrationError();
  //   });
  // }

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
                    onChanged: (value) {
                      _email = value;
                    },
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
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      _password = value;
                    },
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
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      _confirmPassword = value;
                    },
                    decoration: kTextFieldInputDecoration.copyWith(
                      fillColor: kTextIconColour,
                      hintText: 'Confirm Password',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  _registrationError,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Center(
              child: RoundButton(
                label: 'Register',
                onPressed: () async {
                  await _registerScreenViewModel.registerUser(
                      _email, _password, _confirmPassword);
                  setState(() {
                    _registrationError =
                        _registerScreenViewModel.getRegistrationError();
                    // print(_registrationError);
                  });
                },
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
                    _registerScreenViewModel.navigateToLoginScreen(context);
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

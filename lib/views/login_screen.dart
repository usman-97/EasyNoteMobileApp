import 'package:flutter/material.dart';
import 'package:note_taking_app/components/link_button.dart';
import 'package:note_taking_app/components/round_button.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/login_screen_view_model.dart';
import 'package:note_taking_app/views/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginScreenViewModel _loginScreenViewModel = LoginScreenViewModel();
  String _email = '', _password = '';
  String _loginError = '';
  bool _isErrorVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkPrimaryColour,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'EasyNote',
              style: kMainHeadingStyle,
              textAlign: TextAlign.center,
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
            const Flexible(
              child: Text(
                'Capture your ideas',
                style: kMainHeadingSubtitle,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: SizedBox(
                width: 350.0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
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
                    keyboardType: TextInputType.emailAddress,
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
            const SizedBox(
              height: 8.0,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  _loginError,
                  style: kErrorMessageStyle,
                ),
              ),
            ),
            Center(
              child: RoundButton(
                label: 'Login',
                onPressed: () async {
                  await _loginScreenViewModel.loginUser(
                      context, _email, _password);
                  setState(() {
                    _loginError = _loginScreenViewModel.getLoginError();
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Not Registered?',
                  style: TextStyle(
                    color: kTextIconColour,
                    fontSize: 18.0,
                  ),
                ),
                LinkButton(
                  text: 'Register here',
                  onPressed: () {
                    _loginScreenViewModel.navigateToRegisterScreen(context);
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

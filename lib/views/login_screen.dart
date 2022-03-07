import 'package:flutter/material.dart';
import 'package:note_taking_app/components/link_button.dart';
import 'package:note_taking_app/components/main_logo.dart';
import 'package:note_taking_app/components/round_button.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/login_screen_view_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginScreenViewModel _loginScreenViewModel = LoginScreenViewModel();
  // String _email = '', _password = '';
  String _loginError = '';
  bool _isScreenLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkPrimaryColour,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isScreenLoading,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: ListView(
              children: <Widget>[
                const MainLogo(),
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
                          _loginScreenViewModel.email = value;
                        },
                        decoration: kRoundTextFieldInputDecoration.copyWith(
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
                          _loginScreenViewModel.password = value;
                        },
                        decoration: kRoundTextFieldInputDecoration.copyWith(
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
                Column(
                  children: <Widget>[
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
                            Navigation.navigateToRegister(context);
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LinkButton(
                          text: 'Forgot your password?',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: RoundButton(
                    label: 'Login',
                    onPressed: () async {
                      setState(() {
                        _isScreenLoading = true;
                      });
                      await _loginScreenViewModel.loginUser(context);
                      setState(() {
                        _loginError = _loginScreenViewModel.getLoginError();
                        _isScreenLoading = false;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:note_taking_app/components/link_button.dart';
import 'package:note_taking_app/components/main_logo.dart';
import 'package:note_taking_app/components/round_button.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/register_screen_view_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen2';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterScreenViewModel _registerScreenViewModel =
      RegisterScreenViewModel();
  bool _isNextSectionVisible = false, _isScreenLoading = false;
  String _registrationError = '';

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
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const MainLogo(),
                Visibility(
                  visible: !_isNextSectionVisible,
                  child: Center(
                    child: SizedBox(
                      width: 350.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: TextField(
                          key: const Key('firstNameRegistration'),
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _registerScreenViewModel.firstname = value;
                          },
                          decoration: kRoundTextFieldInputDecoration.copyWith(
                            fillColor: kTextIconColour,
                            hintText: 'First name',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !_isNextSectionVisible,
                  child: Center(
                    child: SizedBox(
                      width: 350.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: TextField(
                          key: const Key('lastNameRegistration'),
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _registerScreenViewModel.lastname = value;
                          },
                          decoration: kRoundTextFieldInputDecoration.copyWith(
                            fillColor: kTextIconColour,
                            hintText: 'Last name',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isNextSectionVisible,
                  child: Center(
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
                            _registerScreenViewModel.email = value;
                          },
                          decoration: kRoundTextFieldInputDecoration.copyWith(
                            fillColor: kTextIconColour,
                            hintText: 'Email',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isNextSectionVisible,
                  child: Center(
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
                            _registerScreenViewModel.password = value;
                          },
                          decoration: kRoundTextFieldInputDecoration.copyWith(
                            fillColor: kTextIconColour,
                            hintText: 'Password',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isNextSectionVisible,
                  child: Center(
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
                            _registerScreenViewModel.confirmPassword = value;
                          },
                          decoration: kRoundTextFieldInputDecoration.copyWith(
                            fillColor: kTextIconColour,
                            hintText: 'Confirm Password',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      _registrationError,
                      style: kErrorMessageStyle,
                    ),
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
                        // _registerScreenViewModel.navigateToLoginScreen(context);
                        Navigation.navigateToLogin(context);
                      },
                    ),
                  ],
                ),
                Visibility(
                  visible: !_isNextSectionVisible,
                  child: Center(
                    child: RoundButton(
                      label: 'Next',
                      onPressed: () {
                        setState(() {
                          // print(
                          //     '${_registerScreenViewModel.isFirstNameValid()} ${_registerScreenViewModel.isLastNameValid()}');
                          if (_registerScreenViewModel.isFirstNameValid() &&
                              _registerScreenViewModel.isLastNameValid()) {
                            _registrationError = '';
                            _isNextSectionVisible =
                                _isNextSectionVisible == true ? false : true;
                          } else {
                            _registrationError =
                                _registerScreenViewModel.getRegistrationError();
                          }
                        });
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _isNextSectionVisible,
                  child: Center(
                    child: RoundButton(
                      label: 'Register',
                      onPressed: () async {
                        setState(() {
                          _isScreenLoading = true;
                        });
                        await _registerScreenViewModel.registerUser();
                        setState(() {
                          _registrationError =
                              _registerScreenViewModel.getRegistrationError();
                          if (_registerScreenViewModel.isUserRegistered()) {
                            _registerScreenViewModel.addUserData();
                            // _registerScreenViewModel.navigateToVerificationScreen(context);
                            Navigation.navigateToVerification(context);
                          }
                          _isScreenLoading = false;
                          // print(_registerScreenViewModel.getCurrentUser());
                        });
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _isNextSectionVisible,
                  child: Center(
                    child: RoundButton(
                      label: 'Back',
                      onPressed: () {
                        setState(() {
                          _registerScreenViewModel.firstname = '';
                          _registerScreenViewModel.lastname = '';
                          _isNextSectionVisible =
                              _isNextSectionVisible == true ? false : true;
                          _registrationError = '';
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

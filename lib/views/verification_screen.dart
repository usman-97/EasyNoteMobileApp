import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class VerificationScreen extends StatefulWidget {
  static const String id = 'verification_screen';

  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkPrimaryColour,
      body: SafeArea(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}

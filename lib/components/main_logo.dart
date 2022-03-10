import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class MainLogo extends StatelessWidget {
  const MainLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        Text(
          'EasyNote',
          style: kMainHeadingStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20.0,
          child: Divider(
            thickness: 2.0,
            color: kTextIconColour,
            indent: 50.0,
            endIndent: 50.0,
          ),
        ),
        Text(
          'Capture your ideas',
          style: kMainHeadingSubtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class LinkButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const LinkButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: kLightPrimaryColour,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}

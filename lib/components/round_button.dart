import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {required this.label,
      required this.onPressed,
      this.backgroundColour = kLightPrimaryColour,
      this.colour = kPrimaryTextColour});

  final String label;
  final void Function() onPressed;
  final Color? backgroundColour, colour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Material(
        color: backgroundColour,
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            label,
            style: TextStyle(
              color: colour,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}

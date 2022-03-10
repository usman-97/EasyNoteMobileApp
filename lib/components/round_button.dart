import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class RoundButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const RoundButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Material(
        color: kLightPrimaryColour,
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            label,
            style: const TextStyle(
              color: kPrimaryTextColour,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}

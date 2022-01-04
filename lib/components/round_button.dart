import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class RoundButton extends StatelessWidget {
  final String label;

  const RoundButton({required this.label});

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
          onPressed: () {},
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

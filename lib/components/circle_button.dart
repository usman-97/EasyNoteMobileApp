import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;

  const CircleButton(
      {Key? key, this.icon = Icons.add_rounded, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Icon(
        icon,
        color: kTextIconColour,
        size: 60.0,
      ),
      elevation: 0.0,
      constraints: const BoxConstraints.tightFor(
        width: 100.0,
        height: 100.0,
      ),
      shape: const CircleBorder(),
      fillColor: kAccentColour,
    );
  }
}

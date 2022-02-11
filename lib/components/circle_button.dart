import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;

  const CircleButton({Key? key, this.icon = Icons.add_rounded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigation.navigateToCreateNote(context);
      },
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

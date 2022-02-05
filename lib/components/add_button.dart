import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigation.navigateToCreateNote(context);
      },
      child: const Icon(
        Icons.add_rounded,
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

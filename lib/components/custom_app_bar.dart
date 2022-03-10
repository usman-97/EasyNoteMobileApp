import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';

class CustomAppBar extends StatelessWidget {
  final bool isEditNote;

  const CustomAppBar({
    this.isEditNote = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Visibility(
        child: TextButton(
          onPressed: () {
            Navigation.navigateToSearchNotesScreen(context);
          },
          child: const Icon(
            Icons.search_rounded,
            color: kTextIconColour,
            size: 40.0,
          ),
        ),
      ),
    );
  }
}

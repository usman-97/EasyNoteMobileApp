import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/navigation.dart';

import '../utilities/constants.dart';
import 'bottom_menu_button.dart';

class BottomNoteTypeMenu extends StatelessWidget {
  const BottomNoteTypeMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      color: kLightPrimaryColour,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              BottomMenuButton(
                label: 'Note',
                icon: Icons.note_rounded,
                onPressed: () {
                  Navigation.navigateToCreateNote(context);
                },
              ),
              BottomMenuButton(
                label: 'Sticky Note',
                icon: Icons.sticky_note_2_rounded,
                onPressed: () {
                  Navigation.navigateToCreateStickyNoteScreen(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

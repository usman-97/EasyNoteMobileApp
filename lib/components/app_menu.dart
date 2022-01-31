import 'package:flutter/material.dart';
import 'package:note_taking_app/components/app_menu_card.dart';
import 'package:note_taking_app/utilities/constants.dart';

class AppMenu extends StatelessWidget {
  const AppMenu();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryColour,
            ),
            child: Text('EasyNote'),
          ),
          AppMenuCard(
            cardTitle: 'Notes',
            icon: Icons.note_rounded,
          ),
          AppMenuCard(
            cardTitle: 'Logout',
            icon: Icons.exit_to_app_rounded,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:note_taking_app/components/app_menu_card.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/user_view_model.dart';

class AppMenu extends StatelessWidget {
  final UserViewModel _userViewModel = UserViewModel();

  AppMenu();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryColour,
            ),
            child: Text('EasyNote'),
          ),
          AppMenuCard(
            cardTitle: 'Home',
            icon: Icons.home_rounded,
            onTap: () {
              Navigation.navigateToHome(context);
            },
          ),
          AppMenuCard(
            cardTitle: 'Notes',
            icon: Icons.note_rounded,
            onTap: () {
              Navigation.navigateToNoteList(context);
            },
          ),
          AppMenuCard(
            cardTitle: 'Shared Notes',
            icon: Icons.folder_shared_rounded,
            onTap: () {
              Navigation.navigateToSharedNotesScreen(context);
            },
          ),
          AppMenuCard(
            cardTitle: 'Logout',
            icon: Icons.exit_to_app_rounded,
            onTap: () {
              _userViewModel.signOutUser();
              Navigation.navigateToLogin(context);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:note_taking_app/components/app_menu_card.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/user_view_model.dart';

class AppMenu extends StatefulWidget {
  const AppMenu({Key? key}) : super(key: key);

  @override
  _AppMenuState createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  final UserViewModel _userViewModel = UserViewModel();
  String _userFullName = '';

  @override
  void initState() {
    setUserFullName();
    super.initState();
  }

  void setUserFullName() async {
    _userFullName = await _userViewModel.getUserFullName();
    setState(() {});
    // print(_userFullName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kLightPrimaryColour,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: kDarkPrimaryColour,
            ),
            child: Column(
              children: <Widget>[
                const Expanded(
                  child: Icon(
                    Icons.account_circle_rounded,
                    size: 120.0,
                    color: kLightPrimaryColour,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Text(
                      _userFullName,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: kTextIconColour,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

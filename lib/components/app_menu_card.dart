import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class AppMenuCard extends StatelessWidget {
  final String cardTitle;
  final IconData icon;
  final void Function() onTap;

  const AppMenuCard(
      {required this.cardTitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kDarkPrimaryColour,
      child: ListTile(
        leading: Icon(
          icon,
          color: kTextIconColour,
        ),
        title: Text(
          cardTitle,
          style: const TextStyle(
            color: kTextIconColour,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class AppMenuCard extends StatelessWidget {
  final String cardTitle;
  final IconData icon;

  const AppMenuCard({required this.cardTitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: kPrimaryTextColour,
        ),
        title: Text(cardTitle),
        onTap: () {},
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class BottomMenuButton extends StatelessWidget {
  const BottomMenuButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        color: kDarkPrimaryColour,
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: kTextIconColour,
              size: 80.0,
            ),
            Text(
              label,
              style: const TextStyle(
                color: kTextIconColour,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

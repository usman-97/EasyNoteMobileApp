import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class NoDataMessageWidget extends StatelessWidget {
  const NoDataMessageWidget({
    Key? key,
    required this.message,
    required this.icon,
    this.colour = kPrimaryColour,
  }) : super(key: key);

  final String message;
  final IconData icon;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(
          icon,
          size: 200.0,
          color: colour,
        ),
        Center(
          child: Text(
            message,
            style: const TextStyle(
              color: kPrimaryTextColour,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

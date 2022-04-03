import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class NoDataMessageWidget extends StatelessWidget {
  const NoDataMessageWidget({
    Key? key,
    required this.message,
    required this.icon,
  }) : super(key: key);

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(
          icon,
          size: 200.0,
          color: kPrimaryColour,
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

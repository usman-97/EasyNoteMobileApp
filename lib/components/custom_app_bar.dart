import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: Icon(
        Icons.search_rounded,
        color: kTextIconColour,
        size: 40.0,
      ),
    );
  }
}

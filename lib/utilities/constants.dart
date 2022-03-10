import 'dart:ffi';

import 'package:flutter/material.dart';

const Color kDarkPrimaryColour = Color(0xFF388E3c);
const Color kLightPrimaryColour = Color(0xFFC8E6C9);
const Color kPrimaryColour = Color(0xFF4CAF50);
const Color kTextIconColour = Color(0xFFFFFFFF);
const Color kPrimaryTextColour = Color(0xFF212121);
const Color kAccentColour = Color(0xFF009688);
const Color kTextFieldHintColour = Colors.black26;

const double kTopContainerHeight = 200.0;

const TextStyle kMainHeadingStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Pushster',
  fontSize: 70.0,
);

const TextStyle kMainHeadingSubtitle = TextStyle(
  color: Colors.white,
  fontFamily: 'Indie Flower',
  fontSize: 25.0,
  fontStyle: FontStyle.italic,
);

const TextStyle kErrorMessageStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.red,
);

const InputDecoration kRoundTextFieldInputDecoration = InputDecoration(
  filled: true,
  contentPadding: EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 20.0,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const InputDecoration kNoteTitleInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.zero,
  border: InputBorder.none,
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: kLightPrimaryColour,
    ),
  ),
);

const TextStyle kAppBarTextFieldStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

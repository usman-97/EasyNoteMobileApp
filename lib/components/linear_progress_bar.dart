import 'package:flutter/material.dart';

class LinearProgressBar extends StatelessWidget {
  const LinearProgressBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 300.0,
          height: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 50.0),
          color: const Color(0xFF4CAF50),
        ),
        Container(
          width: controller.value,
          height: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 50.0),
          color: const Color(0xFFC8E6C9),
        ),
      ],
    );
  }
}

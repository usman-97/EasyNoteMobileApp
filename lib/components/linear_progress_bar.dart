import 'package:flutter/material.dart';

class LinearProgressBar extends StatefulWidget {
  const LinearProgressBar({Key? key}) : super(key: key);

  @override
  _LinearProgressBarState createState() => _LinearProgressBarState();
}

class _LinearProgressBarState extends State<LinearProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      upperBound: 300,
    );

    _controller.forward();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          key: const Key('fillBar'),
          width: 300.0,
          height: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 50.0),
          color: const Color(0xFF4CAF50),
        ),
        Container(
          width: _controller.value,
          height: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 50.0),
          color: const Color(0xFFC8E6C9),
        ),
      ],
    );
  }
}

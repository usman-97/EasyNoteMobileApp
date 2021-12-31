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

    // Control animation with this controller
    _controller = AnimationController(
      // Time loading progress bar takes to complete
      duration: const Duration(seconds: 2),
      vsync: this,
      upperBound: 300,
    );

    _controller.forward(); // Start the progress bar

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Destroy the progress bar when user
    // is directed to different screen
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // bar which will be filled
        Container(
          key: const Key('fillBar'),
          width: 300.0,
          height: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 50.0),
          color: const Color(0xFF4CAF50),
        ),
        // Filled bar container
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

import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      upperBound: 300,
    );

    controller.forward();

    controller.addListener(() {
      setState(() {});
      print(controller.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF388E3c),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: Text(
                'EasyNote',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 70.0,
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
              width: 50.0,
            ),
            Stack(
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
            ),
            const SizedBox(
              height: 30.0,
              width: 50.0,
            ),
            const Center(
              child: Text(
                'Capture your ideas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

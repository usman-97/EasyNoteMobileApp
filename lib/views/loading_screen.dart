import 'package:flutter/material.dart';
import 'package:note_taking_app/components/linear_progress_bar.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    // controller = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    //   upperBound: 300,
    // );

    // controller.forward();
    //
    // controller.addListener(() {
    //   setState(() {});
    //   // print(controller.value);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF388E3c),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Center(
              child: Text(
                'EasyNote',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 70.0,
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
              width: 50.0,
            ),
            LinearProgressBar(),
            SizedBox(
              height: 30.0,
              width: 50.0,
            ),
            Center(
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

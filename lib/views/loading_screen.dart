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
              // Main Heading
              child: Text(
                'EasyNote',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Pushster',
                  fontSize: 70.0,
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
              width: 50.0,
            ),
            // Loading progress bar
            LinearProgressBar(
              key: Key('linearProgressBar'),
            ),
            SizedBox(
              height: 30.0,
              width: 50.0,
            ),
            Center(
              // Subtitle
              child: Text(
                'Capture your ideas',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Indie Flower',
                  fontSize: 25.0,
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

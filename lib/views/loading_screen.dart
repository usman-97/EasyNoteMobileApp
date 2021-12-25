import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
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
              child: Center(
                child: Divider(
                  indent: 50.0,
                  endIndent: 50.0,
                  color: Color(0xFFC8E6C9),
                  thickness: 5.0,
                ),
              ),
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

import 'package:flutter/material.dart';
import 'package:note_taking_app/components/linear_progress_bar.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/loading_screen_view_model.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = "loading_screen";

  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final LoadingScreenViewModel loadingScreenViewModel =
      LoadingScreenViewModel();

  @override
  void initState() {
    super.initState();
    loadingScreenViewModel.navigateToLoginScreen(context);
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
                style: kMainHeadingStyle,
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
                style: kMainHeadingSubtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

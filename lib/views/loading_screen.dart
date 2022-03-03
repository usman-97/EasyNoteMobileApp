import 'package:flutter/material.dart';
import 'package:note_taking_app/components/linear_loading_progress_bar.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/loading_screen_view_model.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = "loading_screen";

  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final LoadingScreenViewModel _loadingScreenViewModel =
      LoadingScreenViewModel();

  @override
  void initState() {
    super.initState();
    _loadingScreenViewModel.appLoading(context);
    // _loadingScreenViewModel.isUserSignedIn();
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
            LinearLoadingProgressBar(
              key: Key('linearProgressBar'),
              backgroundColour: Color(0xFF4CAF50),
              colour: Color(0xFFC8E6C9),
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

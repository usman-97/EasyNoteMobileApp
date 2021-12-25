import 'package:flutter/material.dart';
import 'views/loading_screen.dart';

void main() {
  runApp(const EasyNote());
}

class EasyNote extends StatelessWidget {
  const EasyNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF388E3c),
        ),
      ),
      home: const LoadingScreen(),
    );
  }
}

import 'package:flutter/material.dart';

class SharePopUpForm extends StatelessWidget {
  const SharePopUpForm({Key? key, required this.onPressed}) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Share'),
      content: const TextField(
        decoration: InputDecoration(hintText: 'Email'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onPressed,
          child: const Text('Share'),
        )
      ],
    );
  }
}

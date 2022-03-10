import 'package:flutter/material.dart';

class SharePopUpForm extends StatelessWidget {
  const SharePopUpForm(
      {Key? key, required this.onPressed, required this.controller})
      : super(key: key);

  final void Function() onPressed;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Share'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Email'),
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

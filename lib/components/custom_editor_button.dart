import 'package:flutter/material.dart';

class CustomEditorButton extends StatelessWidget {
  const CustomEditorButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Icon(
        icon,
        color: Colors.black,
      ),
    );
  }
}

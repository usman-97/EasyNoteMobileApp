import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {Key? key,
      required this.noteTitle,
      required this.onAccept,
      required this.onRefuse,
      required this.acceptIcon,
      required this.refuseIcon})
      : super(key: key);

  final String noteTitle;
  final Future<void> Function() onAccept;
  final void Function() onRefuse;
  final Icon acceptIcon, refuseIcon;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text('Delete $noteTitle'),
      content: const Text('Are you sure?'),
      actions: <Widget>[
        TextButton(
          onPressed: onAccept,
          child: acceptIcon,
        ),
        TextButton(
          onPressed: onRefuse,
          child: refuseIcon,
        ),
      ],
    );
  }
}

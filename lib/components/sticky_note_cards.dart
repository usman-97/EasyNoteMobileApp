import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class StickyNoteCard extends StatelessWidget {
  const StickyNoteCard({
    Key? key,
    required this.noteID,
    required this.title,
    required this.text,
    required this.onEdit,
    required this.backgroundColour,
  }) : super(key: key);

  final String noteID, title, text;
  final void Function() onEdit;
  final Color backgroundColour;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: backgroundColour,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                text,
                style: const TextStyle(fontSize: 14.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: onEdit,
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 30.0,
                      color: kPrimaryTextColour,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Icon(
                      Icons.delete_rounded,
                      size: 30.0,
                      color: kPrimaryTextColour,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

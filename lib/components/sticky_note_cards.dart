import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class StickyNoteCard extends StatelessWidget {
  const StickyNoteCard({
    Key? key,
    required this.noteID,
    required this.title,
    required this.text,
  }) : super(key: key);

  final String noteID, title, text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Text(
                'title',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy',
                style: TextStyle(fontSize: 14.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.edit_rounded,
                      size: 30.0,
                      color: kPrimaryTextColour,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(
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

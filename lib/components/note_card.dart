import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    Key? key,
    required this.title,
    required this.date_created,
    required this.last_modified,
    required this.status,
    required this.onTap,
  }) : super(key: key);

  final String title, date_created, last_modified, status;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          color: Colors.amberAccent,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(fontSize: 40.0),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Icon(Icons.more_horiz_rounded),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Created: $date_created'),
                        Text('Last Modified: $last_modified'),
                      ],
                    ),
                    Text(status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

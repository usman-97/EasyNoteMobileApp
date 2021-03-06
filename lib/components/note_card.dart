import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note_taking_app/utilities/constants.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    Key? key,
    required this.title,
    required this.dateCreated,
    required this.lastModified,
    required this.status,
    required this.onTap,
    this.onShare,
    this.onDelete,
    this.author = '',
    required this.noteID,
  }) : super(key: key);

  final String noteID, title, dateCreated, lastModified, author;
  final IconData status;
  final void Function() onTap;
  final void Function(BuildContext context)? onShare;
  final Future<void> Function(BuildContext context)? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: status != Icons.preview_rounded && status != Icons.edit_rounded
          ? Slidable(
              key: const ValueKey(0),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: <Widget>[
                  SlidableAction(
                    onPressed: onShare ?? (context) {},
                    backgroundColor: const Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.share_rounded,
                    label: 'Share',
                  ),
                  SlidableAction(
                    onPressed: onDelete ?? (context) {},
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete_rounded,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Card(
                color: kLightPrimaryColour,
                child: Container(
                  decoration: kNoteCardBorder,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 40.0,
                                  fontFamily: 'Righteous Regular',
                                ),
                              ),
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
                                Text(
                                  dateCreated,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Merienda Regular',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  lastModified,
                                  style: const TextStyle(
                                    fontFamily: 'Merienda Regular',
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(status),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Card(
              color: kLightPrimaryColour,
              child: Container(
                decoration: kNoteCardBorder,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 40.0,
                                fontFamily: 'Righteous Regular',
                              ),
                            ),
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
                              Visibility(
                                visible: author.isNotEmpty,
                                child: Text(
                                  'Created by $author',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'Merienda Regular',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                dateCreated,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Merienda Regular',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                lastModified,
                                style: const TextStyle(
                                  fontFamily: 'Merienda Regular',
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(status),
                          ),
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

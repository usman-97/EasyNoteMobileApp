import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    Key? key,
    required this.title,
    required this.date_created,
    required this.last_modified,
    required this.status,
    required this.onTap,
    this.onShare,
    this.onDelete,
    this.access = '',
  }) : super(key: key);

  final String title, date_created, last_modified, status;
  final void Function() onTap;
  final void Function(BuildContext context)? onShare, onDelete;
  final String access;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Slidable(
          key: const ValueKey(0),
          // startActionPane: ActionPane(
          //   motion: const DrawerMotion(),
          //   dismissible: DismissiblePane(
          //     onDismissed: () {},
          //   ),
          //   children: <Widget>[
          //     SlidableAction(
          //       onPressed: (value) {},
          //       backgroundColor: const Color(0xFFFE4A49),
          //       foregroundColor: Colors.white,
          //       icon: Icons.delete_rounded,
          //       label: 'Delete',
          //     ),
          //     SlidableAction(
          //       onPressed: (value) {},
          //       backgroundColor: const Color(0xFF21B7CA),
          //       foregroundColor: Colors.white,
          //       icon: Icons.share_rounded,
          //       label: 'Share',
          //     ),
          //   ],
          // ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: <Widget>[
              // SlidableAction(
              //   onPressed: (value) {},
              //   backgroundColor: const Color(0xFF7BC043),
              //   foregroundColor: Colors.white,
              //   icon: Icons.archive_rounded,
              //   label: 'Archive',
              // ),
              // SlidableAction(
              //   onPressed: (value) {},
              //   backgroundColor: const Color(0xFF0392CF),
              //   foregroundColor: Colors.white,
              //   icon: Icons.save_rounded,
              //   label: 'Save',
              // ),

              SlidableAction(
                onPressed:
                    access.isEmpty ? onShare ?? (context) {} : (context) {},
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.share_rounded,
                label: 'Share',
              ),
              SlidableAction(
                onPressed: (value) {},
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete_rounded,
                label: 'Delete',
              ),
            ],
          ),
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
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(status),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

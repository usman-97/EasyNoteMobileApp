import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(
      {Key? key,
      required this.user,
      required this.noteTile,
      required this.access,
      required this.onAccept,
      required this.onDecline})
      : super(key: key);

  final String user, noteTile, access;
  final Future<void> Function() onAccept, onDecline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        color: kLightPrimaryColour,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Text(
                    '$user wants to share $noteTile note with $access access.'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: onAccept,
                    child: Container(
                      color: Colors.green,
                      child: const Icon(
                        Icons.check_rounded,
                        color: kTextIconColour,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onDecline,
                    child: Container(
                      color: Colors.red,
                      child: const Icon(
                        Icons.close_rounded,
                        color: kTextIconColour,
                      ),
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

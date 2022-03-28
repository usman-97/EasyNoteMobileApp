import 'package:flutter/material.dart';
import 'package:note_taking_app/components/app_menu.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/components/notification_card.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/notifications_view_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  static const String id = 'notifications_screen';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationsViewModel _notificationsViewModel =
      NotificationsViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[
          CustomAppBar(),
        ],
      ),
      drawer: AppMenu(),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
                stream: _notificationsViewModel.getAllSharingRequests(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  final data = snapshot.data;

                  List<NotificationCard> notifications =
                      _notificationsViewModel.buildNotificationCards(snapshot);
                  return ListView(
                    children: notifications,
                    // children: <Widget>[
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 5.0),
                    //     child: Card(
                    //       color: kLightPrimaryColour,
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(5.0),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.stretch,
                    //           children: <Widget>[
                    //             const Center(
                    //               child: Text(
                    //                   'User wants to share Title note with Access.'),
                    //             ),
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 TextButton(
                    //                   onPressed: () {},
                    //                   child: Container(
                    //                     color: Colors.green,
                    //                     child: const Icon(
                    //                       Icons.check_rounded,
                    //                       color: kTextIconColour,
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 TextButton(
                    //                   onPressed: () {},
                    //                   child: Container(
                    //                     color: Colors.red,
                    //                     child: const Icon(
                    //                       Icons.close_rounded,
                    //                       color: kTextIconColour,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ],
                  );
                }),
          ),
        ],
      )),
    );
  }
}

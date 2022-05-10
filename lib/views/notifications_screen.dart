import 'package:flutter/material.dart';
import 'package:note_taking_app/components/app_menu.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/components/no_data_message_widget.dart';
import 'package:note_taking_app/components/notification_card.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
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
        leading: TextButton(
          onPressed: () {
            Navigation.navigateToHome(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: kTextIconColour,
          ),
        ),
        actions: const <Widget>[
          CustomAppBar(),
        ],
      ),
      // drawer: AppMenu(),
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
                    return const NoDataMessageWidget(
                      message: 'You have got no notifications.',
                      icon: Icons.mail_rounded,
                    );
                  }

                  // final data = snapshot.data;

                  List<NotificationCard> notifications =
                      _notificationsViewModel.buildNotificationCards(snapshot);
                  return ListView(
                    children: notifications,
                  );
                }),
          ),
        ],
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:note_taking_app/components/circle_button.dart';
import 'package:note_taking_app/components/app_menu.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/components/no_data_message_widget.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';
import 'package:note_taking_app/viewModels/home_view_model.dart';
import 'package:note_taking_app/views/note_screen/create_note_screen.dart';

import '../components/bottom_note_type_menu.dart';
import '../components/sticky_note_cards.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel _homeViewModel = HomeViewModel();
  final CreateNoteViewModel _createNoteViewModel = CreateNoteViewModel();
  String _todayDate = '';
  String value = '';
  bool _isScreenLoading = false;

  final AssetImage _coverImage = const AssetImage('images/home_background.jpg');

  @override
  void initState() {
    super.initState();
    _todayDate = _homeViewModel.getTodayDate();
  }

  @override
  void dispose() {
    _createNoteViewModel.clearCache();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    await precacheImage(_coverImage, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // precacheImage(_coverImage, context);
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[
          CustomAppBar(),
        ],
      ),
      drawer: const AppMenu(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isScreenLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: kTopContainerHeight,
                // color: kPrimaryColour,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _coverImage,
                    colorFilter: ColorFilter.srgbToLinearGamma(),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            StreamBuilder(
                              stream: _homeViewModel.setUserFirstName(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text('');
                                }

                                return Text(
                                  'Hello, ${snapshot.data.toString()}',
                                  style: kHomeGreetingTextStyle,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              _todayDate,
                              style: kHomeGreetingTextStyle.copyWith(
                                fontSize: 16.0,
                                // fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: kLightPrimaryColour,
                height: 70.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IntrinsicWidth(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Sticky Note Board',
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              color: kAccentColour,
                              height: 5.0,
                            )
                          ],
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          GestureDetector(
                            key: const Key('notification_button'),
                            onTap: () async {
                              await _homeViewModel.readAllNotification();
                              Navigation.navigateToNotificationsScreen(context);
                            },
                            child: const Icon(
                              Icons.notifications_rounded,
                              color: kDarkPrimaryColour,
                              size: 40.0,
                            ),
                          ),
                          StreamBuilder(
                              stream:
                                  _homeViewModel.getTotalUnreadNotification(),
                              builder: (context, snapshot) {
                                _isScreenLoading = true;
                                if (!snapshot.hasData) {
                                  _isScreenLoading = false;
                                  // print('no data');
                                  return Container();
                                }

                                final totalNotifications = snapshot.data;
                                String notificationText = '';
                                if (totalNotifications != null) {
                                  notificationText = '$totalNotifications';
                                }
                                // print(notificationText);
                                _isScreenLoading = false;

                                return notificationText.isEmpty
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.all(5.0),
                                        // color: Colors.red,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Text(
                                          notificationText,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            color: kTextIconColour,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                              }),
                          //  ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      // color: const Color(0xFFe6c7b1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFe6c7b1),
                        border: Border.all(
                          width: 5.0,
                          color: Colors.brown,
                        ),
                      ),
                      child: StreamBuilder(
                        stream: _homeViewModel.getAllUserStickyNotes(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          _isScreenLoading = true;
                          // print(snapshot.hasData);
                          if (!snapshot.hasData) {
                            _isScreenLoading = false;
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, bottom: 55.0),
                              child: const NoDataMessageWidget(
                                message:
                                    'Tap on + button to create a sticky note',
                                icon: Icons.sticky_note_2_rounded,
                              ),
                            );
                          }

                          // print(snapshot.data[0].noteID);
                          // List<Row> userStickyNotesList = _homeViewModel
                          //     .buildStickyNoteCards(context, snapshot);
                          // print(userStickyNotesList[0].children);
                          final stickyNoteContext = context;
                          final data = snapshot;

                          return FutureBuilder(
                              future: _homeViewModel.buildStickyNoteCards(
                                  stickyNoteContext, data),
                              builder: (context, snapshot) {
                                // _isScreenLoading = true;
                                if (!snapshot.hasData) {
                                  _isScreenLoading = false;
                                  return Container();
                                }

                                // print(snapshot.data.runtimeType);
                                List<Row> userStickyNoteList =
                                    snapshot.data as List<Row>;
                                _isScreenLoading = false;
                                return ListView(
                                  children: userStickyNoteList,
                                );
                              });
                        },
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: CircleButton(
                              onPressed: () async {
                                await showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const BottomNoteTypeMenu(
                                        key: Key('choose_note_type'),
                                      );
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

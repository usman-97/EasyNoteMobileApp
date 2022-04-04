import 'package:flutter/material.dart';
import 'package:note_taking_app/components/circle_button.dart';
import 'package:note_taking_app/components/app_menu.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
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
  String _todayDate = '';
  bool _showNoteMenu = false;
  String value = '';

  @override
  void initState() {
    super.initState();
    _todayDate = _homeViewModel.getTodayData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[
          CustomAppBar(),
        ],
      ),
      drawer: const AppMenu(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: kTopContainerHeight,
              // color: kPrimaryColour,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/home_background.jpg'),
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     TextButton(
                    //       key: const Key('home_button'),
                    //       onPressed: () {
                    //         Navigation.navigateToHome(context);
                    //       },
                    //       child: const Icon(
                    //         Icons.home_rounded,
                    //         color: kTextIconColour,
                    //         size: 50.0,
                    //       ),
                    //     ),
                    //     TextButton(
                    //       key: const Key('mode_change_button'),
                    //       onPressed: () {},
                    //       child: const Icon(
                    //         Icons.brightness_2_rounded,
                    //         color: kTextIconColour,
                    //         size: 40.0,
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                            stream: _homeViewModel.getTotalUnreadNotification(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                // print('no data');
                                return Container();
                              }

                              final totalNotifications = snapshot.data;
                              String notificationText = '';
                              if (totalNotifications != null) {
                                notificationText = '$totalNotifications';
                              }
                              // print(notificationText);

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
                    // Row(
                    //   children: <Widget>[
                    //     Container(
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: kPrimaryTextColour,
                    //           width: 2.0,
                    //         ),
                    //         borderRadius: const BorderRadius.only(
                    //             topLeft: Radius.circular(10.0),
                    //             bottomLeft: Radius.circular(10.0)),
                    //       ),
                    //       child: const Padding(
                    //         padding: EdgeInsets.all(5.0),
                    //         child: Text(
                    //           'Recent',
                    //           style: TextStyle(fontSize: 18.0),
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: kPrimaryTextColour,
                    //           width: 2.0,
                    //         ),
                    //         borderRadius: const BorderRadius.only(
                    //             topRight: Radius.circular(10.0),
                    //             bottomRight: Radius.circular(10.0)),
                    //       ),
                    //       child: const Padding(
                    //         padding: EdgeInsets.all(5.0),
                    //         child: Text(
                    //           'Categories',
                    //           style: TextStyle(fontSize: 18.0),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                    child: ListView(
                      children: <Widget>[
                        Row(
                          children: const <Widget>[
                            StickyNoteCard(
                              noteID: '',
                              title: 'title',
                              text: '',
                            ),
                            StickyNoteCard(
                              noteID: '',
                              title: 'title',
                              text: '',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // Visibility(
                        //   visible: _showNoteMenu,
                        //   child: Flexible(
                        //     child: Card(
                        //       color: kAccentColour,
                        //       child: Column(
                        //         children: <Widget>[
                        //           Container(
                        //             color: kAccentColour,
                        //             child: TextButton(
                        //               onPressed: () {
                        //                 Navigation.navigateToCreateNote(
                        //                     context);
                        //               },
                        //               child: const Text(
                        //                 'Note',
                        //                 style:
                        //                     TextStyle(color: kTextIconColour),
                        //               ),
                        //             ),
                        //           ),
                        //           Container(
                        //             color: kAccentColour,
                        //             child: TextButton(
                        //               onPressed: () {
                        //                 Navigator.push(context,
                        //                     MaterialPageRoute(
                        //                         builder: (context) {
                        //                   return const CreateNoteScreen(
                        //                     type: 'Sticky Note',
                        //                   );
                        //                 }));
                        //               },
                        //               child: const Text(
                        //                 'Sticky Note',
                        //                 style:
                        //                     TextStyle(color: kTextIconColour),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: _showNoteMenu,
                        //   child: PopupMenuButton<String>(
                        //     onSelected: (String result) {
                        //       setState(() {
                        //         value = result;
                        //       });
                        //     },
                        //     itemBuilder: (BuildContext context) =>
                        //         <PopupMenuEntry<String>>[
                        //       const PopupMenuItem<String>(
                        //         value: '',
                        //         child: Text('Working a lot harder'),
                        //       ),
                        //       const PopupMenuItem<String>(
                        //         value: '',
                        //         child: Text('Being a lot smarter'),
                        //       ),
                        //       const PopupMenuItem<String>(
                        //         value: '',
                        //         child: Text('Being a self-starter'),
                        //       ),
                        //       const PopupMenuItem<String>(
                        //         value: '',
                        //         child:
                        //             Text('Placed in charge of trading charter'),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CircleButton(
                            onPressed: () {
                              // Navigation.navigateToCreateNote(context);
                              // setState(() {
                              //   _showNoteMenu = !_showNoteMenu ? true : false;
                              //   // print(_showNoteMenu);
                              // });

                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const BottomNoteTypeMenu();
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Align(
                  //   alignment: FractionalOffset.bottomCenter,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(bottom: 20.0),
                  //     child: CircleButton(
                  //       onPressed: () {
                  //         Navigation.navigateToCreateNote(context);
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

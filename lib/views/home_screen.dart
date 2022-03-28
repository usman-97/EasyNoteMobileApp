import 'package:flutter/material.dart';
import 'package:note_taking_app/components/circle_button.dart';
import 'package:note_taking_app/components/app_menu.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel _homeViewModel = HomeViewModel();
  String _todayDate = '';

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
      drawer: AppMenu(),
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
                    GestureDetector(
                      onTap: () {
                        Navigation.navigateToNotificationsScreen(context);
                      },
                      child: const Icon(
                        Icons.notifications_rounded,
                        color: kDarkPrimaryColour,
                        size: 40.0,
                      ),
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
                  ListView(),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CircleButton(
                        onPressed: () {
                          Navigation.navigateToCreateNote(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

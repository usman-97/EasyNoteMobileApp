import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:note_taking_app/components/circle_button.dart';
import 'package:note_taking_app/components/app_menu.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/components/note_card.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';
import 'package:note_taking_app/viewModels/note_list_view_model.dart';
import 'package:note_taking_app/views/note_screen/create_note_screen.dart';
import 'package:note_taking_app/views/home_screen.dart';

import '../components/no_data_message_widget.dart';

class NoteListScreen extends StatefulWidget {
  static const String id = 'note_list_screen';

  const NoteListScreen({Key? key}) : super(key: key);

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final NoteListViewModel _noteListViewModel = NoteListViewModel();
  final CreateNoteViewModel _createNoteViewModel = CreateNoteViewModel();
  bool _isScreenLoading = false;

  @override
  void initState() {
    super.initState();
    // _createNoteViewModel.clearCache();
    // _createNoteViewModel.listAllFiles();
  }

  @override
  Widget build(BuildContext context) {
    // _noteListViewModel.fetchAllUserNotes();
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[
          CustomAppBar(),
        ],
      ),
      drawer: AppMenu(),
      backgroundColor: kTextIconColour,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isScreenLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: kPrimaryColour,
                height: 150.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      key: const Key('note_list_back_button'),
                      onPressed: () {
                        Navigator.pushNamed(context, HomeScreen.id);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: kTextIconColour,
                          size: 40.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        'Notes',
                        key: Key('note_list_screen_heading'),
                        style: TextStyle(
                          color: kTextIconColour,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    StreamBuilder(
                      stream: _noteListViewModel.fetchAllUserNotes(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        _isScreenLoading = true;
                        if (!snapshot.hasData) {
                          // print('No data found.');
                          _isScreenLoading = false;
                          return const NoDataMessageWidget(
                            message: 'Tap + button to create a new note.',
                            icon: Icons.note_rounded,
                          );
                        }
                        _isScreenLoading = false;

                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   _isScreenLoading = true;
                        // } else {
                        //   _isScreenLoading = false;
                        // }

                        List<NoteCard> userNotes = _noteListViewModel
                            .buildUserNoteCards(snapshot, context);
                        // print(userNotes.length);
                        // print(_noteListViewModel.noteMenuValue);
                        return ListView(
                          children: userNotes,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: CircleButton(
                          onPressed: () {
                            Navigator.pushNamed(context, CreateNoteScreen.id);
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:note_taking_app/components/app_menu.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/components/no_data_message_widget.dart';
import 'package:note_taking_app/components/note_card.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/note_list_view_model.dart';
import 'package:note_taking_app/viewModels/shared_notes_view_model.dart';

import 'home_screen.dart';

class SharedNoteScreen extends StatefulWidget {
  const SharedNoteScreen({Key? key}) : super(key: key);

  static const String id = 'shared_notes_screen';

  @override
  State<SharedNoteScreen> createState() => _SharedNoteScreenState();
}

enum SharingOptions {
  userSharedNotes,
  otherUserSharedNotes,
}

class _SharedNoteScreenState extends State<SharedNoteScreen> {
  final SharedNotesViewModel _sharedNotesViewModel = SharedNotesViewModel();
  final NoteListViewModel _noteListViewModel = NoteListViewModel();
  int _option = 0;

  @override
  void dispose() {
    _sharedNotesViewModel.otherSharedNoteData.close();
    super.dispose();
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
      backgroundColor: kTextIconColour,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_rounded,
              // color: kTextIconColour,
              size: 30.0,
            ),
            label: '',
            // icon: Icon(Icons.account_box_multiple_rounded, color: kTextIconColour),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_alt_rounded,
              // color: kTextIconColour,
              size: 30.0,
            ),
            label: '',
          ),
        ],
        currentIndex: _option,
        backgroundColor: kDarkPrimaryColour,
        unselectedItemColor: kTextIconColour,
        selectedItemColor: kLightPrimaryColour,
        onTap: (index) {
          setState(() {
            _option = index;
          });
        },
      ),
      body: SafeArea(
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
                      'Shared Notes',
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
            Visibility(
              visible: _option == SharingOptions.userSharedNotes.index,
              child: Expanded(
                child: StreamBuilder(
                    stream: _sharedNotesViewModel.getUserSharedNotes(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      // _sharedNotesViewModel.getUserSharedNotes();
                      if (!snapshot.hasData) {
                        return const NoDataMessageWidget(
                            message: 'No shared notes found.',
                            icon: Icons.share_rounded);
                      }

                      List<NoteCard> sharedNoteCardList = _noteListViewModel
                          .buildUserNoteCards(snapshot, context);

                      return ListView(
                        children: sharedNoteCardList,
                      );
                    }),
              ),
            ),
            Visibility(
              visible: _option == SharingOptions.otherUserSharedNotes.index,
              child: Expanded(
                child: StreamBuilder(
                  stream: _sharedNotesViewModel.getOtherSharedNotes(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    // _sharedNotesViewModel.getOtherUserSharedNoteData();
                    // print(snapshot.hasData);
                    if (!snapshot.hasData) {
                      return const NoDataMessageWidget(
                          message: 'No shared note by other user found.',
                          icon: Icons.share_rounded);
                    }

                    // print(snapshot.data);
                    List<NoteCard> otherSharedUserNoteCards =
                        _sharedNotesViewModel.buildOtherUserSharedNotes(
                            snapshot, context);

                    return ListView(
                      children: otherSharedUserNoteCards,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

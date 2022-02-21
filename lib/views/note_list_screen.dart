import 'package:flutter/material.dart';
import 'package:note_taking_app/components/circle_button.dart';
import 'package:note_taking_app/components/app_menu.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/components/noteCard.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/note_list_view_model.dart';
import 'package:note_taking_app/views/home_screen.dart';
import 'package:provider/provider.dart';

class NoteListScreen extends StatefulWidget {
  static const String id = 'note_list_screen';

  const NoteListScreen({Key? key}) : super(key: key);

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final NoteListViewModel _noteListViewModel = NoteListViewModel();

  @override
  Widget build(BuildContext context) {
    // _noteListViewModel.fetchAllUserNotes();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteListViewModel()),
      ],
      child: Scaffold(
        appBar: AppBar(
          actions: const <Widget>[
            CustomAppBar(),
          ],
        ),
        drawer: AppMenu(),
        backgroundColor: kLightPrimaryColour,
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
                        'Notes',
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
                        // final notesData = snapshot.data;
                        // List<NoteCard> userNoteCards = [];
                        // for (var noteData in notesData) {
                        //   userNoteCards.add(NoteCard(
                        //       title: noteData.note_title,
                        //       date_created: noteData.date_created,
                        //       last_modified: noteData.last_modified,
                        //       status: noteData.status));
                        // }

                        _noteListViewModel.buildUserNoteCards(snapshot);
                        return ListView(
                          children: _noteListViewModel.userNoteCards,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
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
      ),
    );
  }
}

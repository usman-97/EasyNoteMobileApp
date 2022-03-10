import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/note_list_view_model.dart';
import 'package:note_taking_app/viewModels/search_notes_view_model.dart';
import 'package:note_taking_app/components/note_card.dart';
import 'package:note_taking_app/components/note_pop_up_menu.dart';

class SearchNoteScreen extends StatefulWidget {
  static const String id = 'search_note_screen';

  const SearchNoteScreen({Key? key}) : super(key: key);

  @override
  _SearchNoteScreenState createState() => _SearchNoteScreenState();
}

class _SearchNoteScreenState extends State<SearchNoteScreen> {
  final TextEditingController _searchTextFieldController =
      TextEditingController();
  final SearchNotesViewModel _searchNotesViewModel = SearchNotesViewModel();
  final NoteListViewModel _noteListViewModel = NoteListViewModel();
  // String _keyword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightPrimaryColour,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_outlined,
            color: kTextIconColour,
            size: 30.0,
          ),
        ),
        title: TextField(
          controller: _searchTextFieldController,
          onChanged: (value) {
            if (value.isNotEmpty) {
              _searchNotesViewModel.keyword = value;
              // print(_searchNotesViewModel.keyword);
              _searchNotesViewModel.getAllSearchUserNotes();
            }
          },
          style: kAppBarTextFieldStyle.copyWith(color: kPrimaryTextColour),
          decoration: kRoundTextFieldInputDecoration.copyWith(
            fillColor: kTextIconColour,
            hintStyle: const TextStyle(color: kTextFieldHintColour),
            hintText: 'Search...',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Icon(
              Icons.search_rounded,
              color: kTextIconColour,
              size: 40.0,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: _searchNotesViewModel.streamController.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  List<NoteCard> searchedNoteCards =
                      _noteListViewModel.buildUserNoteCards(snapshot, context);

                  return ListView(
                    children: searchedNoteCards,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

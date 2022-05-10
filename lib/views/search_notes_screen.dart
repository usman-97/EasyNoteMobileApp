import 'package:flutter/material.dart';
import 'package:note_taking_app/components/no_data_message_widget.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/note_list_view_model.dart';
import 'package:note_taking_app/viewModels/search_notes_view_model.dart';
import 'package:note_taking_app/components/note_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTextIconColour,
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          decoration: const BoxDecoration(
            color: kPrimaryColour,
            // border: Border(
            //   bottom: BorderSide(),
            // ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextField(
                    controller: _searchTextFieldController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _searchNotesViewModel.keyword = value;
                        // print(_searchNotesViewModel.keyword);
                        _searchNotesViewModel.getAllSearchUserNotes();
                        setState(() {});
                      }
                    },
                    style: kAppBarTextFieldStyle.copyWith(
                        color: kTextIconColour, fontSize: 16.0),
                    decoration: const InputDecoration(
                      fillColor: kPrimaryColour,
                      filled: true,
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: kDarkPrimaryColour,
                        size: 30.0,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchTextFieldController.clear();
                  });
                },
                child: Visibility(
                  visible: _searchTextFieldController.text.isNotEmpty,
                  child: const Icon(
                    Icons.close_rounded,
                    color: kTextIconColour,
                    size: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
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
                    return NoDataMessageWidget(
                        message:
                            'Your Search ${_searchTextFieldController.text} did not match any note.',
                        icon: Icons.search_rounded);
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

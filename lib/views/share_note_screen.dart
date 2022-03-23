import 'package:flutter/material.dart';
import 'package:note_taking_app/components/round_button.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/share_note_view_model.dart';

class ShareNoteScreen extends StatefulWidget {
  const ShareNoteScreen({Key? key, this.noteID = ''}) : super(key: key);

  static const String id = 'share_note_screen';
  final String noteID;

  @override
  State<ShareNoteScreen> createState() => _ShareNoteScreenState();
}

class _ShareNoteScreenState extends State<ShareNoteScreen> {
  final ShareNoteViewModel _shareNoteViewModel = ShareNoteViewModel();
  final TextEditingController _shareController = TextEditingController();

  bool _isReadOnly = true;
  String _userAccess = 'Read-only', _error = '';
  late String _noteID;

  @override
  void initState() {
    super.initState();

    _noteID = widget.noteID;
    // print(_noteID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColour,
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            color: kLightPrimaryColour,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 5.0),
                  child: TextField(
                    controller: _shareController,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: 'user@example.com',
                      fillColor: kTextIconColour,
                      filled: true,
                    ),
                  ),
                ),
                Visibility(
                  visible: _shareNoteViewModel.error.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: Text(
                      _shareNoteViewModel.error,
                      style: kErrorMessageStyle.copyWith(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _userAccess = 'Read-only';
                          _isReadOnly = true;
                        });
                      },
                      child: Container(
                        color:
                            _isReadOnly ? kDarkPrimaryColour : kTextIconColour,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Read-only',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: _isReadOnly
                                  ? kTextIconColour
                                  : kDarkPrimaryColour,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _userAccess = 'Read/Write';
                          _isReadOnly = false;
                        });
                      },
                      child: Container(
                        color:
                            !_isReadOnly ? kDarkPrimaryColour : kTextIconColour,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Read/Write',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: !_isReadOnly
                                  ? kTextIconColour
                                  : kDarkPrimaryColour,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                RoundButton(
                    label: 'Share',
                    backgroundColour: kAccentColour,
                    colour: kTextIconColour,
                    onPressed: () async {
                      await _shareNoteViewModel.shareUserNote(
                          _noteID, _shareController.text, _userAccess);
                      setState(() {
                        // _error = _shareNoteViewModel.error;
                      });
                    }),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as text_editor;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';
import 'package:note_taking_app/views/note_screen/note_screen_interface.dart';

import '../../components/circle_button.dart';

class CreateNotebookScreen extends StatefulWidget {
  const CreateNotebookScreen(
      {Key? key,
      this.notebookID = '',
      this.notebookTitle = 'Untitled',
      this.access = '',
      this.user = '',
      this.author = '',
      this.isNotebookEditable = true})
      : super(key: key);

  static const String id = 'create_notebook_screen';
  final String notebookID, notebookTitle, access, user, author;
  final bool isNotebookEditable;

  @override
  State<CreateNotebookScreen> createState() => _CreateNotebookScreenState();
}

class _CreateNotebookScreenState extends State<CreateNotebookScreen>
    implements INoteScreen {
  final CreateNoteViewModel _createNoteViewModel = CreateNoteViewModel();
  text_editor.QuillController _quillController =
      text_editor.QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _titleTextFieldController =
      TextEditingController();
  late String _notebookID, _notebookTitle, _access, _user, _author;
  late bool _isNoteEditable;
  bool _isToolBarExpanded = false;

  @override
  void initState() {
    _notebookID = widget.notebookID;
    _titleTextFieldController.text = _notebookTitle = widget.notebookTitle;
    _access = widget.access;
    _user = widget.user;
    _author = widget.author;
    _isNoteEditable = widget.isNotebookEditable;

    super.initState();
  }

  @override
  void loadDoc(String filename) {
    // TODO: implement loadDoc
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            if (!_isNoteEditable) {
              Navigator.pop(context);
            }
          },
          child: Icon(
            _isNoteEditable ? Icons.check_rounded : Icons.arrow_back_rounded,
            size: 40.0,
            color: kTextIconColour,
          ),
        ),
        title: TextField(
          controller: _titleTextFieldController,
          enabled: _isNoteEditable,
          textAlign: TextAlign.center,
          style: kAppBarTextFieldStyle,
          decoration: kNoteTitleInputDecoration,
        ),
        actions: <Widget>[
          _isNoteEditable
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      _isNoteEditable = false;
                    });
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    size: 40.0,
                    color: kTextIconColour,
                  ),
                )
              : Container(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Visibility(
              visible: _isNoteEditable,
              child: Column(
                children: <Widget>[
                  text_editor.QuillToolbar.basic(
                    controller: _quillController,
                    onImagePickCallback:
                        _createNoteViewModel.onImagePickCallback,
                    onVideoPickCallback:
                        _createNoteViewModel.onVideoPickCallBack,
                    showAlignmentButtons: true,
                    multiRowsDisplay: _isToolBarExpanded,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isToolBarExpanded = _isToolBarExpanded ? false : true;
                      });
                    },
                    child: Icon(
                      _isToolBarExpanded
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // flex: 10,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: text_editor.QuillEditor(
                  controller: _quillController,
                  focusNode: _focusNode,
                  scrollController: ScrollController(),
                  scrollable: true,
                  padding: EdgeInsets.zero,
                  autoFocus: true,
                  readOnly: !_isNoteEditable,
                  expands: true,
                  showCursor: _isNoteEditable,
                ),
              ),
            ),
            Visibility(
              visible: !_isNoteEditable && _access != 'Read-only',
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: const Icon(
                        Icons.navigate_next_rounded,
                      ),
                    ),
                    CircleButton(
                      onPressed: () {
                        setState(() {
                          _isNoteEditable = true;
                        });
                      },
                      icon: Icons.edit_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

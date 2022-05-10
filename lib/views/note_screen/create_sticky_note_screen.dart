import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';
import 'package:note_taking_app/viewModels/create_sticky_note_view_model.dart';
import 'package:note_taking_app/views/note_screen/note_screen_interface.dart';
import 'package:flutter_quill/flutter_quill.dart' as text_editor;

import '../../components/circle_button.dart';
import '../../utilities/constants.dart';

class CreateStickyNoteScreen extends StatefulWidget {
  const CreateStickyNoteScreen({
    Key? key,
    this.documentID = '',
    this.title = 'Untitled',
    this.isEditable = true,
    this.user = '',
    this.author = '',
  }) : super(key: key);

  static const String id = 'create_sticky_note_screen';
  final bool isEditable;
  final String documentID, title, user, author;

  @override
  State<CreateStickyNoteScreen> createState() => _CreateStickyNoteScreenState();
}

class _CreateStickyNoteScreenState extends State<CreateStickyNoteScreen>
    implements INoteScreen {
  final CreateStickyNoteViewModel _createStickyNoteViewModel =
      CreateStickyNoteViewModel();
  final CreateNoteViewModel _createNoteViewModel = CreateNoteViewModel();
  text_editor.QuillController _quillController =
      text_editor.QuillController.basic();
  final TextEditingController _titleTextFieldController =
      TextEditingController();
  late bool _isNoteEditable;
  bool _isToolBarExpanded = false, _isScreenLoading = false;
  final FocusNode _focusNode = FocusNode();

  late String _documentID, _title, _author;

  @override
  void initState() {
    _documentID = widget.documentID;
    _titleTextFieldController.text = _title = widget.title;
    _author = widget.author;
    _isNoteEditable = widget.isEditable;

    loadDoc(_documentID);
    super.initState();
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  void loadDoc(String filename) async {
    if (filename.isNotEmpty) {
      _isScreenLoading = true;
      final doc = await _createNoteViewModel.downloadNoteFromCloud(
          filename, 'sticky_notes');
      setState(() {
        _quillController = text_editor.QuillController(
          document: doc,
          selection: const TextSelection(baseOffset: 0, extentOffset: 0),
          keepStyleOnNewLine: true,
        );
        _isScreenLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () async {
            if (_isNoteEditable) {
              setState(() {
                _isScreenLoading = true;
              });

              var document = _quillController.document.toDelta().toJson();
              await _createStickyNoteViewModel.addUserStickyNote(
                  _documentID, _title, _titleTextFieldController.text);
              await _createStickyNoteViewModel.uploadStickyNoteToCloud(
                  document, _documentID, 'sticky_notes');

              setState(() {
                _isScreenLoading = false;
                _isNoteEditable = false;
              });
            } else {
              Navigation.navigateToHome(context);
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
          Visibility(
            visible: _isNoteEditable,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isNoteEditable = false;
                });
              },
              child: const Icon(
                Icons.close_rounded,
                color: kTextIconColour,
                size: 35.0,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isScreenLoading,
          child: Column(
            children: <Widget>[
              Visibility(
                visible: _isNoteEditable,
                child: Column(
                  children: <Widget>[
                    text_editor.QuillToolbar.basic(
                      controller: _quillController,
                      showImageButton: false,
                      showVideoButton: false,
                      showCameraButton: false,
                      showAlignmentButtons: true,
                      multiRowsDisplay: _isToolBarExpanded,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isToolBarExpanded =
                              _isToolBarExpanded ? false : true;
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
                visible: !_isNoteEditable,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: CircleButton(
                    onPressed: () {
                      setState(() {
                        _isNoteEditable = true;
                      });
                    },
                    icon: Icons.edit_rounded,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:note_taking_app/components/circle_button.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';
import 'package:flutter_quill/flutter_quill.dart' as text_editor;
import 'package:note_taking_app/views/note_screen/note_screen_interface.dart';

class CreateNoteScreen extends StatefulWidget {
  static const String id = 'create_note_screen';
  final bool isEditable;
  final String documentID, title, user, author, access, jsonDocument;

  const CreateNoteScreen({
    Key? key,
    this.documentID = '',
    this.title = 'Untitled',
    this.isEditable = true,
    this.access = '',
    this.user = '',
    this.author = '',
    this.jsonDocument = '',
  }) : super(key: key);

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen>
    implements INoteScreen {
  text_editor.QuillController _quillController =
      text_editor.QuillController.basic();
  final CreateNoteViewModel _createNoteViewModel = CreateNoteViewModel();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _titleTextFieldController =
      TextEditingController();
  late bool _isNoteEditable, _isToolBarExpanded = false;
  late String _documentID, _title, _access, _author, _jsonDocumentData;

  bool _isScreenLoading = false;

  @override
  void initState() {
    _titleTextFieldController.text = _title = widget.title;
    _isNoteEditable = widget.isEditable;
    _documentID = widget.documentID;
    _access = widget.access;
    _author = widget.author;
    _jsonDocumentData = widget.jsonDocument;

    if (_author.isNotEmpty) {
      _createNoteViewModel.setAuthor(_author);
    }

    loadDoc(_documentID);

    super.initState();
  }

  @override
  void loadDoc(String filename) async {
    if (filename.isNotEmpty) {
      _isScreenLoading = true;
      await _createNoteViewModel.downloadAttachmentFiles(filename);
    }
    final text_editor.Document doc;
    if (_jsonDocumentData.isEmpty) {
      doc = await _createNoteViewModel.downloadNoteFromCloud(filename, 'notes');
    } else {
      doc = text_editor.Document.fromJson(jsonDecode(_jsonDocumentData));
    }
    setState(() {
      _quillController = text_editor.QuillController(
        document: doc,
        selection: const TextSelection(baseOffset: 0, extentOffset: 0),
        keepStyleOnNewLine: true,
      );
      _isScreenLoading = false;
    });
  }

  @override
  void dispose() {
    _createNoteViewModel.clearCache();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(_createNoteViewModel.attachmentName);
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () async {
            if (!_isNoteEditable) {
              // _createNoteViewModel.clearCache();
              Navigator.pop(context);
            } else {
              var document = _quillController.document.toDelta().toJson();

              setState(() {
                _isScreenLoading = true;
              });
              await _createNoteViewModel.addNote(
                  _documentID, _titleTextFieldController.text, _title);
              if (_documentID.isEmpty) {
                _documentID = _createNoteViewModel.currentDocumentID;
              }

              await _createNoteViewModel.uploadNoteToCloud(
                  document, _documentID, 'notes');
              _createNoteViewModel.uploadUserAttachment(_documentID,
                  _titleTextFieldController.text, document.toString());
              _title = _titleTextFieldController.text;
              // _createNoteViewModel.listAllFiles();
              setState(() {
                _isScreenLoading = false;
                _isNoteEditable = false;
                FocusManager.instance.primaryFocus?.unfocus();
              });
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
                if (_documentID.isNotEmpty) {
                  _isNoteEditable = false;
                  loadDoc(_documentID);
                } else {
                  Navigation.navigateToNoteList(context);
                }
              },
              child: const Icon(
                Icons.close_rounded,
                color: kTextIconColour,
                size: 35.0,
              ),
            ),
          ),
          Visibility(
            visible: !_isNoteEditable,
            child: PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        onTap: () async {
                          final file = jsonEncode(
                              _quillController.document.toDelta().toJson());
                          _createNoteViewModel.saveNoteAsJson(
                              file.toString(), _title);
                        },
                        child: const Text("Export"),
                        value: 1,
                      ),
                      PopupMenuItem(
                        onTap: () {
                          // Share.shareFiles();
                          _createNoteViewModel.shareNoteAsJson(_documentID);
                        },
                        child: const Text("Share"),
                        value: 2,
                      ),
                      const PopupMenuItem(
                        child: Text("Print"),
                        value: 3,
                      ),
                    ]),
          ),
        ],
      ),
      // drawer: AppMenu(),
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
                visible: !_isNoteEditable && _access != 'Read-only',
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

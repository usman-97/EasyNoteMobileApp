import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:note_taking_app/components/circle_button.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CreateNoteScreen extends StatefulWidget {
  static const String id = 'create_note_screen';
  final bool isEditable;
  final String documentID, title, user, author, access;

  const CreateNoteScreen({
    Key? key,
    this.documentID = '',
    this.title = 'Untitled',
    this.isEditable = true,
    this.access = '',
    this.user = '',
    this.author = '',
  }) : super(key: key);

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  QuillController _quillController = QuillController.basic();
  final CreateNoteViewModel _createNoteViewModel = CreateNoteViewModel();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _titleTextFieldController =
      TextEditingController();
  late bool _isNoteEditable, _isToolBarExpanded = false;
  late String _documentID, _title, _access, _author;

  bool _isScreenLoading = false;

  @override
  void initState() {
    _titleTextFieldController.text = _title = widget.title;
    _isNoteEditable = widget.isEditable;
    _documentID = widget.documentID;
    _access = widget.access;
    _author = widget.author;

    if (_author.isNotEmpty) {
      _createNoteViewModel.setAuthor(_author);
    }

    _loadDoc(_documentID);

    // _createNoteViewModel.listAllFiles();
    super.initState();
  }

  void _loadDoc(String filename) async {
    if (filename.isNotEmpty) {
      _isScreenLoading = true;
      await _createNoteViewModel.downloadAttachmentFiles(filename);
      final doc = await _createNoteViewModel.downloadNoteFromCloud(filename);
      // _createNoteViewModel.listAllFiles();
      setState(() {
        _quillController = QuillController(
            document: doc,
            selection: const TextSelection(baseOffset: 0, extentOffset: 0),
            keepStyleOnNewLine: true);
        _isScreenLoading = false;
      });
    }
  }

  @override
  void dispose() {
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
              _createNoteViewModel.clearCache();
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
                  document, _documentID, _titleTextFieldController.text);
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
                  _loadDoc(_documentID);
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
                    QuillToolbar.basic(
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
                  child: QuillEditor(
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

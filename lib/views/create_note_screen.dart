import 'package:flutter/material.dart';
import 'package:note_taking_app/components/circle_button.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CreateNoteScreen extends StatefulWidget {
  static const String id = 'create_note_screen';
  final bool isEditable;
  final String documentID, title;

  const CreateNoteScreen({
    Key? key,
    this.documentID = '',
    this.title = 'Untitled',
    this.isEditable = true,
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
  late bool _isEditNote, _isToolBarExpaneded = false;
  late String documentID, title;

  @override
  void initState() {
    super.initState();
    _titleTextFieldController.text = widget.title;
    _isEditNote = widget.isEditable;
    documentID = widget.documentID;
    _loadDoc(documentID);
  }

  void _loadDoc(String filename) async {
    final doc = await _createNoteViewModel.downloadNoteFromCloud(filename);
    if (filename.isNotEmpty) {
      setState(() {
        _quillController = QuillController(
            document: doc,
            selection: const TextSelection(baseOffset: 0, extentOffset: 0));
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
            if (!_isEditNote) {
              Navigation.navigateToNoteList(context);
            } else {
              // String noteDoc = await _createNoteViewModel.generateDocumentName(
              //         documentID, _titleTextFieldController.text),
              //     id = await _createNoteViewModel.generateDocumentID(
              //         documentID, _titleTextFieldController.text);
              // int totalNotes = await _createNoteViewModel.getTotalNotes();
              // if (documentID.isEmpty) {
              //   noteDoc =
              //       '${_titleTextFieldController.text}${totalNotes + 1}.json';
              //   id = _titleTextFieldController.text;
              // } else {
              //   noteDoc = '$documentID.json';
              //   id = documentID;
              // }
              var document = _quillController.document.toDelta().toJson();
              await _createNoteViewModel.uploadNoteToCloud(
                  document, documentID, _titleTextFieldController.text);
              // await _createNoteViewModel.uploadNoteToCloud(document, noteDoc);
              await _createNoteViewModel.addNote(
                  documentID, _titleTextFieldController.text);
              setState(() {
                _isEditNote = false;
                FocusManager.instance.primaryFocus?.unfocus();
              });
            }
          },
          child: Icon(
            _isEditNote ? Icons.check_rounded : Icons.arrow_back_rounded,
            size: 40.0,
            color: kTextIconColour,
          ),
        ),
        title: TextField(
          controller: _titleTextFieldController,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
          decoration: kNoteTitleInputDecoration,
        ),
      ),
      // drawer: AppMenu(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Visibility(
              visible: _isEditNote,
              child: Column(
                children: <Widget>[
                  QuillToolbar.basic(
                    controller: _quillController,
                    onImagePickCallback:
                        _createNoteViewModel.onImagePickCallback,
                    onVideoPickCallback:
                        _createNoteViewModel.onVideoPickCallBack,
                    showAlignmentButtons: true,
                    multiRowsDisplay: _isToolBarExpaneded,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isToolBarExpaneded =
                            _isToolBarExpaneded ? false : true;
                      });
                    },
                    child: Icon(
                      _isToolBarExpaneded
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
                  readOnly: !_isEditNote,
                  expands: true,
                  showCursor: _isEditNote,
                ),
              ),
            ),
            Visibility(
              visible: !_isEditNote,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircleButton(
                  onPressed: () {
                    setState(() {
                      _isEditNote = true;
                    });
                  },
                  icon: Icons.edit_rounded,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

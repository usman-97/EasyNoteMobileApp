import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app/components/app_menu.dart';
import 'package:note_taking_app/components/circle_button.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/components/custom_editor_button.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';
import 'package:flutter_quill/flutter_quill.dart';

// import 'package:html_editor_enhanced/html_editor.dart';
// import 'package:html_editor_enhanced/utils/callbacks.dart';
// import 'package:html_editor_enhanced/utils/file_upload_model.dart';
// import 'package:html_editor_enhanced/utils/options.dart';
// import 'package:html_editor_enhanced/utils/plugins.dart';
// import 'package:html_editor_enhanced/utils/shims/dart_ui.dart';
// import 'package:html_editor_enhanced/utils/shims/dart_ui_fake.dart';
// import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
// import 'package:html_editor_enhanced/utils/shims/flutter_inappwebview_fake.dart';
// import 'package:html_editor_enhanced/utils/toolbar.dart';
// import 'package:html_editor_enhanced/utils/utils.dart';

class CreateNoteScreen extends StatefulWidget {
  static const String id = 'create_note_screen';
  final CameraDescription cameraDescription;

  const CreateNoteScreen({Key? key, required this.cameraDescription})
      : super(key: key);

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final QuillController _quillController = QuillController.basic();
  final CreateNoteViewModel _createNoteViewModel = CreateNoteViewModel();
  // final HtmlEditorController _htmlEditorController = HtmlEditorController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _titleTextFieldController =
      TextEditingController();
  bool _isEditNote = true;

  // late final CameraController _cameraController;
  // late final Future<void> _initializeControllerFuture;
  // bool _isCameraShown = false;

  @override
  void initState() {
    super.initState();
    _titleTextFieldController.text = 'Untitled';
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _htmlEditorController.setFullScreen();
    // print(_isEditNote);
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () async {
            if (!_isEditNote) {
              Navigation.navigateToNoteList(context);
            } else {
              var document = _quillController.document.toDelta().toJson();
              // await _createNoteViewModel.uploadNoteToCloud(
              //     document, 'filename');
              await _createNoteViewModel
                  .addNoteToFirestore(_titleTextFieldController.text);
              setState(() {
                _isEditNote = false;
                FocusManager.instance.primaryFocus?.unfocus();
                // _htmlEditorController.disable();
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
            // Expanded(
            //   child: Stack(
            //     children: <Widget>[
            //       HtmlEditor(
            //         controller: _htmlEditorController,
            //         htmlEditorOptions: const HtmlEditorOptions(
            //           hint: 'Your text here...',
            //           shouldEnsureVisible: true,
            //           spellCheck: true,
            //         ),
            //         otherOptions: const OtherOptions(
            //           height: 1200,
            //         ),
            //         htmlToolbarOptions: HtmlToolbarOptions(
            //           toolbarType: ToolbarType.nativeExpandable,
            //           customToolbarButtons: <Widget>[
            //             //   TextButton(
            //             //     onPressed: () {
            //             //       setState(() {
            //             //         _isCameraShown = true;
            //             //       });
            //             //     },
            //             //     child: const Icon(
            //             //       Icons.camera_enhance_rounded,
            //             //       color: Colors.black87,
            //             //     ),
            //             //   ),
            //             Row(
            //               children: <Widget>[
            //                 CustomEditorButton(
            //                   icon: Icons.undo_rounded,
            //                   onPressed: () {
            //                     _htmlEditorController.undo();
            //                   },
            //                 ),
            //                 CustomEditorButton(
            //                   icon: Icons.redo_rounded,
            //                   onPressed: () {
            //                     _htmlEditorController.redo();
            //                   },
            //                 ),
            //               ],
            //             )
            //           ],
            //           defaultToolbarButtons: [
            //             const StyleButtons(),
            //             const FontSettingButtons(
            //               fontSizeUnit: false,
            //             ),
            //             const ColorButtons(),
            //             const ListButtons(listStyles: false),
            //             const ParagraphButtons(
            //               lineHeight: false,
            //               caseConverter: false,
            //             ),
            //             const InsertButtons(),
            //           ],
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(bottom: 20.0),
            //         child: Visibility(
            //           visible: !_isEditNote,
            //           child: Align(
            //             alignment: FractionalOffset.bottomCenter,
            //             child: CircleButton(
            //               icon: Icons.edit_rounded,
            //               onPressed: () {
            //                 setState(() {
            //                   _htmlEditorController.enable();
            //                   _isEditNote = true;
            //                 });
            //               },
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            Visibility(
              visible: _isEditNote,
              child: QuillToolbar.basic(
                controller: _quillController,
                onImagePickCallback: _createNoteViewModel.onImagePickCallback,
                onVideoPickCallback: _createNoteViewModel.onVideoPickCallBack,
                showAlignmentButtons: true,
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

            // const SizedBox(
            //   height: 50.0,
            // ),
            // Expanded(
            //   flex: 5,
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 10.0,
            //       vertical: 15.0,
            //     ),
            //     child: QuillEditor.basic(
            //       controller: _quillController,
            //       readOnly: false,
            //     ),
            //   ),
            // ),
            // Visibility(
            //   visible: !_isEditNote,
            //   child: Align(
            //     alignment: FractionalOffset.bottomCenter,
            //     child: CircleButton(
            //       onPressed: () {
            //         setState(() {
            //           _isEditNote = true;
            //         });
            //       },
            //       icon: Icons.edit_rounded,
            //     ),
            //   ),
            // ),

            // Expanded(
            //   child: Stack(
            //     children: [
            //       Expanded(
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(
            //             horizontal: 10.0,
            //             vertical: 15.0,
            //           ),
            //           child: QuillEditor.basic(
            //             controller: _quillController,
            //             readOnly: false,
            //           ),
            //         ),
            //       ),
            //       Visibility(
            //         visible: !_isEditNote,
            //         child: Align(
            //           alignment: FractionalOffset.bottomCenter,
            //           child: Padding(
            //             padding: const EdgeInsets.only(bottom: 20.0),
            //             child: CircleButton(
            //               onPressed: () {
            //                 setState(() {
            //                   _isEditNote = true;
            //                 });
            //               },
            //               icon: Icons.edit_rounded,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Visibility(
            //   visible: !_isEditNote,
            //   child: CircleButton(
            //     onPressed: () {
            //       setState(() {
            //         _isEditNote = true;
            //       });
            //     },
            //     icon: Icons.edit_rounded,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

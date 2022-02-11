import 'package:flutter/material.dart';
import 'package:note_taking_app/components/app_menu.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/utilities/constants.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';

import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/utils/callbacks.dart';
import 'package:html_editor_enhanced/utils/file_upload_model.dart';
import 'package:html_editor_enhanced/utils/options.dart';
import 'package:html_editor_enhanced/utils/plugins.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_fake.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
import 'package:html_editor_enhanced/utils/shims/flutter_inappwebview_fake.dart';
import 'package:html_editor_enhanced/utils/toolbar.dart';
import 'package:html_editor_enhanced/utils/utils.dart';

class CreateNoteScreen extends StatefulWidget {
  static const String id = 'create_note_screen';

  const CreateNoteScreen({Key? key}) : super(key: key);

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  // final QuillController _quillController = QuillController.basic();
  final HtmlEditorController _htmlEditorController = HtmlEditorController();
  final CreateNoteViewModel _createNoteViewModel = CreateNoteViewModel();
  bool _isEditNote = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Visibility(
            visible: !_isEditNote,
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 40.0,
              color: kTextIconColour,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // setState(() {
              //   _isEditNote = _isEditNote ? false : true;
              //   print(_isEditNote);
              // });
            },
            child: Icon(
              _isEditNote ? Icons.check_rounded : Icons.edit_rounded,
              color: kTextIconColour,
              size: 40.0,
            ),
          )
        ],
      ),
      // drawer: AppMenu(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: HtmlEditor(
                controller: _htmlEditorController,
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: 'Your text here...',
                  spellCheck: true,
                  shouldEnsureVisible: true,
                ),
                otherOptions: const OtherOptions(
                  height: 400,
                ),
                htmlToolbarOptions: const HtmlToolbarOptions(
                  toolbarType: ToolbarType.nativeGrid,
                  defaultToolbarButtons: [
                    StyleButtons(),
                    FontSettingButtons(
                      fontSizeUnit: false,
                    ),
                    ColorButtons(),
                    ListButtons(listStyles: false),
                    ParagraphButtons(
                      lineHeight: false,
                      caseConverter: false,
                    ),
                    InsertButtons(),
                  ],
                ),
              ),
            ),

            // Visibility(
            //   visible: _isEditNote,
            //   child: QuillToolbar.basic(
            //     controller: _quillController,
            //     onImagePickCallback: _createNoteViewModel.onImagePickCallback,
            //     onVideoPickCallback: _createNoteViewModel.onVideoPickCallBack,
            //   ),
            // ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 10.0,
            //       vertical: 15.0,
            //     ),
            //     child: QuillEditor.basic(
            //       controller: _quillController,
            //       readOnly: !_isEditNote,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

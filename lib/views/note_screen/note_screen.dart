import 'package:flutter_quill/flutter_quill.dart' as text_editor;

abstract class NoteScreen {
  final text_editor.QuillToolbar toolbar = (controller) {
    return text_editor.QuillToolbar.basic(
      controller: controller,
      showAlignmentButtons: true,
    );
  } as text_editor.QuillToolbar;
}

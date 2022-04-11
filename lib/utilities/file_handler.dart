import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart';

class FileHandler {
  void shareNoteAsJson(String noteID) async {
    Directory dir = await getTemporaryDirectory();

    Share.shareFiles(['${dir.path}/files/$noteID']);
  }

  Future<void> saveFileAsJson(String file, String filename) async {
    List<int> encodedFile = utf8.encode(file.toString());
    Uint8List data = Uint8List.fromList(encodedFile);
    await FileSaver.instance.saveAs(filename, data, 'json', MimeType.JSON);
  }

  String getFilename(String path) {
    return basenameWithoutExtension(path);
  }
}

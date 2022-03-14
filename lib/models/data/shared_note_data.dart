import 'package:cloud_firestore/cloud_firestore.dart';

class SharedNoteData {
  final String note_id, author;
  final DocumentReference note;

  SharedNoteData(
      {required this.note_id, required this.author, required this.note});

  SharedNoteData.fromJson(Map<String, dynamic> jsonData)
      : note_id = jsonData['note_id'],
        author = jsonData['author'],
        note = jsonData['note'];

  Map<String, dynamic> toJson() =>
      {'note_id': note_id, 'author': author, 'note': note};
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserStickyNoteData {
  UserStickyNoteData(
      this.noteID, this.noteTitle, this.dateCreated, this.lastModified);

  final String noteID, noteTitle, dateCreated, lastModified;

  UserStickyNoteData.fromJson(Map<String, dynamic> jsonData)
      : noteID = jsonData['id'],
        noteTitle = jsonData['title'],
        dateCreated = jsonData['date_created'],
        lastModified = jsonData['last_modified'];

  Map<String, dynamic> toJson() => {
        'id': noteID,
        'title': noteTitle,
        'date_created': dateCreated,
        'last_modified': lastModified,
      };
}

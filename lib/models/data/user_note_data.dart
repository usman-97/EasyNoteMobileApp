import 'package:cloud_firestore/cloud_firestore.dart';

class UserNoteData {
  final String documentID,
      noteTitle,
      dateCreated,
      lastModified,
      lastModifiedTime,
      status;
  UserNoteData(
      {required this.documentID,
      required this.noteTitle,
      required this.dateCreated,
      required this.lastModified,
      required this.lastModifiedTime,
      required this.status});

  UserNoteData.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.get('id'),
        noteTitle = snapshot.get('title'),
        dateCreated = snapshot.get('date_created'),
        lastModified = snapshot.get('last_modified'),
        lastModifiedTime = snapshot.get('last_modified_time'),
        status = snapshot.get('status');

  UserNoteData.fromJson(Map<String, dynamic> jsonData)
      : documentID = jsonData['id'],
        noteTitle = jsonData['title'],
        dateCreated = jsonData['date_created'],
        lastModified = jsonData['last_modified'],
        lastModifiedTime = jsonData['last_modified_time'],
        status = jsonData['status'];

  Map<String, dynamic> toJson() => {
        'id': documentID,
        'title': noteTitle,
        'date_created': dateCreated,
        'last_modified': lastModified,
        'status': status,
      };
}

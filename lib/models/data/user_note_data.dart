import 'package:cloud_firestore/cloud_firestore.dart';

class UserNoteData {
  final String documentID, note_title, date_created, last_modified, status;
  UserNoteData(
      {required this.documentID,
      required this.note_title,
      required this.date_created,
      required this.last_modified,
      required this.status});

  UserNoteData.fromDocumentSnapshot(Map<String, dynamic> jsonData)
      : documentID = jsonData['id'],
        note_title = jsonData['title'],
        date_created = jsonData['date_created'],
        last_modified = jsonData['last_modified'],
        status = jsonData['status'];

  Map<String, dynamic> toJson() => {
        'id': documentID,
        'title': note_title,
        'date_created': date_created,
        'last_modified': last_modified,
        'status': status,
      };

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': documentID,
  //     'title': note_title,
  //     'date_created': date_created,
  //     'last_modified': last_modified,
  //     'status': status,
  //   };
  // }
  //
  // static fromMap(Map<String, dynamic> map) {
  //   if (map == null) return null;
  //
  //   return UserNoteData(
  //     documentID: map['id'],
  //     note_title: map['note_title'],
  //     date_created: map['date_created'],
  //     last_modified: map['last_modified'],
  //     status: map['status'],
  //   );
  // }

  // UserNoteData(QueryDocumentSnapshot<Map<String, dynamic>> data) {
  //   _documentID = data.get('id');
  //   _note_title = data.get('title');
  //   _date_created = data.get('date_created');
  //   _last_modified = data.get('last_modified');
  //   _status = data.get('status');
  // }
  //
  // get status => _status;
  //
  // get last_modified => _last_modified;
  //
  // get date_created => _date_created;
  //
  // get note_title => _note_title;
  //
  // String get documentID => _documentID;
}

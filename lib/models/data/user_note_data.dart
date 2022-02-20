import 'package:cloud_firestore/cloud_firestore.dart';

class UserNoteData {
  late String _documentID, _note_title, _date_created, _last_modified, _status;

  UserNoteData(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    _documentID = data.get('id');
    _note_title = data.get('title');
    _date_created = data.get('date_created');
    _last_modified = data.get('last_modified');
    _status = data.get('status');
  }

  get status => _status;

  get last_modified => _last_modified;

  get date_created => _date_created;

  get note_title => _note_title;

  String get documentID => _documentID;
}

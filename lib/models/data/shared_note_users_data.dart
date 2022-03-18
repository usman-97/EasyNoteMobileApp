import 'package:cloud_firestore/cloud_firestore.dart';

class SharedNoteUsersData {
  final String user, access;
  final DocumentReference noteRef;

  SharedNoteUsersData(
      {required this.user, required this.access, required this.noteRef});

  SharedNoteUsersData.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : user = snapshot.get('user'),
        access = snapshot.get('access'),
        noteRef = snapshot.get('note');

  SharedNoteUsersData.fromJson(Map<String, dynamic> jsonData)
      : user = jsonData['user'],
        access = jsonData['access'],
        noteRef = jsonData['note'];

  Map<String, dynamic> toJson() => {
        'user': user,
        'access': access,
        'note': noteRef,
      };
}

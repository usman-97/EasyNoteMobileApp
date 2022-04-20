import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

class UserNotebook {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  String _userEmail = '';

  UserNotebook() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  Future<void> addUserNotebook(
      String notebookTitle, String date, String time, String status) async {
    String notebookID = await generateNotebookID();

    try {
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notebooks')
          .add({
        'id': notebookID,
        'title': notebookTitle,
        'date_created': date,
        'last_modified': date,
        'last_modified_time': time,
        'status': status,
      });
    } on FirebaseException catch (e) {}
  }

  Future<String> generateNotebookID() async {
    int idNum = await getLastNotebookIDNumber();
    return 'Notebook${idNum + 1}';
  }

  Future<int> getLastNotebookIDNumber() async {
    int lastNotebookIDNum = 0;

    try {
      CollectionReference notebookColRef = _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notebooks');
      await notebookColRef.get().then((value) {
        if (value.docs.isNotEmpty) {
          for (final doc in value.docs) {
            String notebookID = doc.get('id');
            String idNumStr = notebookID.replaceAll(RegExp(r'[^0-9]'), '');
            int idNum = int.parse(idNumStr);

            if (idNum > lastNotebookIDNum) {
              lastNotebookIDNum = idNum;
            }
          }
        }
      });
    } on FirebaseException catch (e) {}

    return lastNotebookIDNum;
  }

  Future<int> getTotalUserNotebooks() async {
    int totalUserNotebooks = 0;

    try {
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notebooks')
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          totalUserNotebooks = value.docs.length;
        }
      });
    } on FirebaseException catch (e) {}

    return totalUserNotebooks;
  }

  Future<void> updateLastModified(
      String notebookID, String date, String time) async {
    try {
      CollectionReference notebookColRef = _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notebooks');
      await notebookColRef
          .where('id', isEqualTo: notebookID)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await notebookColRef.doc(value.docs.first.id).update({
            'last_modified': date,
            'last_modified_time': time,
          });
        }
      });
    } on FirebaseException catch (e) {}
  }

  Future<void> updateNotebookTitle(
      String notebookID, String notebookTitle) async {
    try {
      CollectionReference notebookColRef = _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notebooks');
      await notebookColRef
          .where('id', isEqualTo: notebookID)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await notebookColRef.doc(value.docs.first.id).update({
            'title': notebookTitle,
          });
        }
      });
    } on FirebaseException catch (e) {}
  }
}

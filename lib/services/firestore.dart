import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(String note) {
    final user = FirebaseAuth.instance.currentUser;
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
      'uid': user?.uid,
    });
  }

  Stream<QuerySnapshot> getNotesStream() {
    final user = FirebaseAuth.instance.currentUser;
    return notes
        .where('uid', isEqualTo: user?.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> editNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get();
  }
}

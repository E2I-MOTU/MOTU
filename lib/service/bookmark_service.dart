import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../view/terminology/event_bus.dart';

class BookmarkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addBookmark(String term, String definition, String example, String category) async {
    User? user = _auth.currentUser;
    if (user != null) {
      CollectionReference bookmarks = _firestore.collection('users').doc(user.uid).collection('bookmarks');
      QuerySnapshot existingBookmark = await bookmarks.where('term', isEqualTo: term).get();

      if (existingBookmark.docs.isEmpty) {
        await bookmarks.add({
          'term': term,
          'definition': definition,
          'example': example,
          'category': category,
          'timestamp': FieldValue.serverTimestamp(),
        });
        eventBus.fire(BookmarkEvent(term, true));
      }
    }
  }

  Future<void> deleteBookmark(String term) async {
    User? user = _auth.currentUser;
    if (user != null) {
      CollectionReference bookmarks = _firestore.collection('users').doc(user.uid).collection('bookmarks');
      QuerySnapshot existingBookmark = await bookmarks.where('term', isEqualTo: term).get();

      for (var doc in existingBookmark.docs) {
        await doc.reference.delete();
      }
      eventBus.fire(BookmarkEvent(term, false));
    }
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    }
    return [];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/bookmark_event.dart';

class BookmarkService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _bookmarks = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  BookmarkProvider() {
    fetchBookmarks();
  }

  Future<void> fetchBookmarks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bookmarks = await getBookmarks();
    } catch (e) {
      _error = '오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBookmark(
      String term, String definition, String example, String category) async {
    User? user = _auth.currentUser;
    if (user != null) {
      CollectionReference bookmarks =
          _firestore.collection('user').doc(user.uid).collection('bookmarks');
      QuerySnapshot existingBookmark =
          await bookmarks.where('term', isEqualTo: term).get();

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

  // 중복 XX, 상태 관리 담당
  Future<void> manageDeleteBookmark(String bookmarkId) async {
    try {
      var bookmark =
          _bookmarks.firstWhere((bookmark) => bookmark['id'] == bookmarkId);
      await deleteBookmark(bookmark['term']);
      _bookmarks.removeWhere((bookmark) => bookmark['id'] == bookmarkId);
      notifyListeners();
    } catch (e) {
      _error = '삭제 중 오류가 발생했습니다.';
      notifyListeners();
    }
  }

  // 중복 XX, DB 관련 처리
  Future<void> deleteBookmark(String term) async {
    User? user = _auth.currentUser;
    if (user != null) {
      CollectionReference bookmarks =
          _firestore.collection('user').doc(user.uid).collection('bookmarks');
      QuerySnapshot existingBookmark =
          await bookmarks.where('term', isEqualTo: term).get();

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
          .collection('user')
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

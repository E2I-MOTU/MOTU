import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bookmark_service.dart';
import '../model/bookmark_event.dart';

class TermCardService with ChangeNotifier {
  List<Map<String, String>> words = [];
  PageController pageController = PageController(initialPage: 0);
  int current = 0;
  Set<String> bookmarkedWords = {};
  StreamSubscription<BookmarkEvent>? _subscription;
  bool _disposed = false;

  TermCardService() {
    _subscription = eventBus.on<BookmarkEvent>().listen((event) {
      if (_disposed) return;

      if (event.isBookmarked) {
        bookmarkedWords.add(event.term);
      } else {
        bookmarkedWords.remove(event.term);
      }
      notifyListeners();
    });
  }

  bool get isDisposed => _disposed;

  Future<void> fetchWords(String title) async {
    if (isDisposed) return;

    CollectionReference collection =
        FirebaseFirestore.instance.collection('terminology');
    DocumentSnapshot snapshot = await collection.doc(title).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      List<Map<String, String>> fetchedWords = [];
      if (data.containsKey('word')) {
        data['word'].forEach((key, value) {
          fetchedWords.add({
            'term': key ?? '',
            'definition': value['meaning'] ?? '',
            'example': value['example'] ?? '',
            'category': title
          });
        });
      }

      words = fetchedWords;
      if (!isDisposed) {
        notifyListeners();
      }
    } else {
      words = [];
      if (!isDisposed) {
        notifyListeners();
      }
    }
  }

  void nextPage() {
    if (isDisposed) return;

    if (current < words.length) {
      pageController.animateToPage(
        current + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      current++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (isDisposed) return;

    if (current > 0) {
      pageController.animateToPage(
        current - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      current--;
      notifyListeners();
    }
  }

  void setCurrentPage(int index) {
    if (isDisposed) return;

    current = index;
    notifyListeners();
  }

  bool get isLastPage {
    return current == words.length;
  }

  Future<void> toggleBookmark(String term) async {
    if (isDisposed) return;

    if (bookmarkedWords.contains(term)) {
      await BookmarkService().deleteBookmark(term);
      bookmarkedWords.remove(term);
      eventBus.fire(BookmarkEvent(term, false));
    } else {
      final word = words.firstWhere((word) => word['term'] == term);
      await BookmarkService().addBookmark(
        term,
        word['definition']!,
        word['example']!,
        word['category']!,
      );
      bookmarkedWords.add(term);
      eventBus.fire(BookmarkEvent(term, true));
    }
    if (!isDisposed) {
      notifyListeners();
    }
  }

  Future<void> fetchBookmarkedWords() async {
    if (isDisposed) return;

    final bookmarks = await BookmarkService().getBookmarks();
    bookmarkedWords =
        bookmarks.map((bookmark) => bookmark['term'] as String).toSet();
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    pageController.dispose();
    super.dispose();
  }
}

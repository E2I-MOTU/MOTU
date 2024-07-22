import 'package:flutter/material.dart';
import '../../service/bookmark_service.dart';

class BookmarkProvider extends ChangeNotifier {
  final BookmarkService _bookmarkService = BookmarkService();
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
      _bookmarks = await _bookmarkService.getBookmarks();
    } catch (e) {
      _error = '오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBookmark(String bookmarkId) async {
    try {
      await _bookmarkService.deleteBookmark(bookmarkId);
      _bookmarks.removeWhere((bookmark) => bookmark['id'] == bookmarkId);
      notifyListeners();
    } catch (e) {
      _error = '삭제 중 오류가 발생했습니다.';
      notifyListeners();
    }
  }
}

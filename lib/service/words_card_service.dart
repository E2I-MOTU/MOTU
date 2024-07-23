import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordsProvider with ChangeNotifier {
  List<Map<String, String>> words = [];
  PageController pageController = PageController(initialPage: 0);
  int current = 0;

  Future<void> fetchWords(String title) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('terminology');
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
      notifyListeners();
    } else {
      words = [];
      notifyListeners();
    }
  }

  void nextPage() {
    if (current < words.length) {
      pageController.animateToPage(
        current + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      current++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (current > 0) {
      pageController.animateToPage(
        current - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      current--;
      notifyListeners();
    }
  }

  void setCurrentPage(int index) {
    current = index;
    notifyListeners();
  }

  bool get isLastPage {
    return current == words.length;
  }
}

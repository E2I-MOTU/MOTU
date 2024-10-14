import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkData {
  String term;
  String definition;
  String example;
  String category;
  Timestamp timestamp;

  BookmarkData({
    required this.term,
    required this.definition,
    required this.example,
    required this.category,
    required this.timestamp,
  });

  factory BookmarkData.fromMap(Map<String, dynamic> map) {
    return BookmarkData(
      term: map['term'],
      definition: map['definition'],
      example: map['example'],
      category: map['category'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'term': term,
      'definition': definition,
      'example': example,
      'category': category,
      'timestamp': timestamp,
    };
  }
}

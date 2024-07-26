import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;

  Article({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
  });

  factory Article.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Article(
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      topics: List<String>.from(data['topics'] ?? []),
    );
  }

  String get topicsAsString {
    return topics.join(', ');
  }
}

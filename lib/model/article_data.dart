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

  // Firestore 데이터에서 Article 객체 생성
  factory Article.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Article(
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      topics: List<String>.from(data['topics'] ?? []),
    );
  }

  // Firestore에 저장할 데이터 형식
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'topics': topics,
    };
  }
}

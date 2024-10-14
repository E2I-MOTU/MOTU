import 'package:cloud_firestore/cloud_firestore.dart';

class Completed {
  bool isCompleted;
  Timestamp completedAt;
  int score;

  Completed({
    required this.isCompleted,
    required this.completedAt,
    required this.score,
  });

  factory Completed.fromMap(Map<String, dynamic> map) {
    return Completed(
      isCompleted: map['completed'],
      completedAt: map['completedAt'],
      score: map['score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'completed': isCompleted,
      'completedAt': completedAt,
      'score': score,
    };
  }
}

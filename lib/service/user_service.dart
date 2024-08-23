import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:developer' as dev;

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserBalance(String uid, int additionalBalance) async {
    try {
      final userRef = _firestore.collection('user').doc(uid);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        final userData = snapshot.data()!;
        final currentBalance = userData['balance'] ?? 0;
        final newBalance = currentBalance + additionalBalance;

        transaction.update(userRef, {'balance': newBalance});
      });
    } catch (e) {
      print('Error updating user balance: $e');
    }
  }

  // 경제/금융 퀴즈
  Future<void> saveQuizCompletion(
      String uid, String quizId, int score, int questionLength) async {
    try {
      final userQuizRef = _firestore
          .collection('user')
          .doc(uid)
          .collection('completedQuiz')
          .doc(quizId);
      final snapshot = await userQuizRef.get();

      bool wasPreviouslyCompleted = false;
      int previousScore = 0;
      if (snapshot.exists) {
        final quizData = snapshot.data()!;
        wasPreviouslyCompleted = quizData['completed'] ?? false;
        previousScore = quizData['score'] ?? 0;
      }

      final newCompleted =
          wasPreviouslyCompleted || (score / questionLength >= 0.9);
      final finalScore =
          wasPreviouslyCompleted ? max(score, previousScore) : score;

      await userQuizRef.set({
        'score': finalScore,
        'completedAt': Timestamp.now(),
        'completed': newCompleted,
      });
    } catch (e) {
      print('Error saving quiz completion: $e');
    }
  }

  Future<Map<String, dynamic>?> getQuizProgress(
      String uid, String quizId) async {
    try {
      final userQuizRef = _firestore
          .collection('user')
          .doc(uid)
          .collection('completedQuiz')
          .doc(quizId);
      final snapshot = await userQuizRef.get();
      // dev.log('Quiz progress: ${snapshot.data()}');
      return snapshot.data();
    } catch (e) {
      print('Error getting quiz progress: $e');
      return null;
    }
  }
}

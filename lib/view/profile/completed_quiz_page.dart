import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import '../../service/user_service.dart';
import '../theme/color_theme.dart';
import '../quiz/widget/quiz_category_builder.dart';

class CompletedQuizPage extends StatelessWidget {
  const CompletedQuizPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchCompletedQuizData(String uid) async {
    final userService = UserService();
    final firestore = FirebaseFirestore.instance;

    // Fetch all quizzes
    final quizCollection = await firestore.collection('quiz').get();
    final quizDocs = quizCollection.docs;

    // Fetch progress for each quiz
    List<Future<Map<String, dynamic>?>> progressFutures = quizDocs.map((quiz) {
      var quizId = quiz.id;
      return userService.getQuizProgress(uid, quizId);
    }).toList();

    // Wait for all progress queries to complete
    final progressSnapshots = await Future.wait(progressFutures);

    List<Map<String, dynamic>> completedQuizData = [];

    for (var i = 0; i < quizDocs.length; i++) {
      var quiz = quizDocs[i];
      var progress = progressSnapshots[i];
      var data = quiz.data() as Map<String, dynamic>;
      var quizId = quiz.id;
      var score = progress != null ? (progress['score'] ?? 0) : 0;
      var totalQuestions = progress != null ? (progress['totalQuestions'] ?? 15) : 15;
      var isCompleted = progress != null ? score >= totalQuestions * 0.9 : false;

      log(progress.toString());

      if (isCompleted) {
        completedQuizData.add({
          'quizId': quizId,
          'catchphrase': data['catchphrase'] ?? '설명 없음',
          'score': score,
          'totalQuestions': totalQuestions,
        });
      }
    }

    return completedQuizData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.colorNeutral,
      appBar: AppBar(
        backgroundColor: ColorTheme.colorWhite,
        title: const Text(
          '완료된 퀴즈 목록',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userSnapshot.hasError || !userSnapshot.hasData) {
            return const Center(child: Text('사용자 정보를 불러올 수 없습니다.'));
          }

          final user = userSnapshot.data!;
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchCompletedQuizData(user.uid),
            builder: (context, quizSnapshot) {
              if (quizSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (quizSnapshot.hasError) {
                return const Center(child: Text('퀴즈 데이터를 불러오는 중 오류가 발생했습니다.'));
              }
              if (!quizSnapshot.hasData || quizSnapshot.data!.isEmpty) {
                return const Center(child: Text('해결 완료한 퀴즈가 없습니다.'));
              }

              var completedQuizzes = quizSnapshot.data!;
              List<Widget> quizCards = completedQuizzes.map((quizData) {
                return buildQuizCard(
                  context: context,
                  uid: user.uid,
                  quizId: quizData['quizId'] as String,
                  catchphrase: quizData['catchphrase'] as String,
                  score: quizData['score'] as int,
                  totalQuestions: quizData['totalQuestions'] as int,
                  isCompleted: true,
                  isNewQuiz: false,
                );
              }).toList();

              return GridView.count(
                padding: const EdgeInsets.all(20),
                crossAxisCount: 2,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 1.6 / 2,
                children: quizCards,
              );
            },
          );
        },
      ),
    );
  }
}

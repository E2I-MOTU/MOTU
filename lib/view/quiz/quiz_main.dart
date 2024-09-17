import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/provider/quiz_provider.dart';
import 'package:motu/view/quiz/widget/quiz_category_builder.dart';
import '../../provider/navigation_provider.dart';
import '../../service/user_service.dart';
import '../main_page.dart';
import '../theme/color_theme.dart';

class QuizSelectionScreen extends StatelessWidget {
  final String uid;
  final UserService _userService = UserService();

  QuizSelectionScreen({super.key, required this.uid});

  Future<Map<String, dynamic>> getProgress(String collectionName) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final totalQuestions =
        (await firestore.collection('quiz').doc(collectionName).get())
                .data()
                ?.length ??
            0;
    final completedQuestions =
        (await firestore.collection('user_progress').doc(collectionName).get())
                .data()?['completed'] ??
            0;
    return {
      'total': totalQuestions,
      'completed': completedQuestions,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.colorNeutral,
      appBar: AppBar(
        backgroundColor: ColorTheme.colorWhite,
        title: const Text(
          '경제/금융 퀴즈',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.left_chevron),
          onPressed: () {
            NavigationService().setSelectedIndex(1);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
              (route) => false, // 모든 기존 경로를 제거
            );
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('quiz').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("퀴즈 데이터를 불러올 수 없습니다."));
              }

              var quizCollections = snapshot.data!.docs;
              List<Future<Map<String, dynamic>?>> progressFutures =
                  quizCollections.map((quiz) {
                var quizId = quiz.id;
                return QuizService().getQuizProgress(uid, quizId);
              }).toList();

              return FutureBuilder<List<Map<String, dynamic>?>>(
                future: Future.wait(progressFutures),
                builder: (context, progressSnapshots) {
                  if (progressSnapshots.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<Widget> completedQuizzes = [];
                  List<Widget> incompleteQuizzes = [];
                  List<Widget> newQuizzes = [];

                  for (var i = 0; i < quizCollections.length; i++) {
                    var quiz = quizCollections[i];
                    var progress = progressSnapshots.data?[i];
                    var data = quiz.data() as Map<String, dynamic>;
                    var quizId = quiz.id;
                    var score = progress != null ? (progress['score'] ?? 0) : 0;
                    var totalQuestions = progress != null
                        ? (progress['totalQuestions'] ?? 15)
                        : 15;
                    var isCompleted = progress != null
                        ? score >= totalQuestions * 0.9
                        : false;
                    var isNewQuiz = progress == null;

                    log(progress.toString());

                    var quizCard = buildQuizCard(
                      context: context,
                      uid: uid,
                      quizId: quizId,
                      catchphrase: data['catchphrase'] ?? '설명 없음',
                      score: score,
                      totalQuestions: totalQuestions,
                      isCompleted: isCompleted,
                      isNewQuiz: isNewQuiz,
                    );

                    if (isCompleted) {
                      completedQuizzes.add(quizCard);
                    } else if (isNewQuiz) {
                      newQuizzes.add(quizCard);
                    } else {
                      incompleteQuizzes.add(quizCard);
                    }
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 1.6 / 2,
                    children: newQuizzes + incompleteQuizzes + completedQuizzes,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

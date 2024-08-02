import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'quiz_screen.dart';
import '../../service/user_service.dart';
import 'widget/circle_indicator.dart';

class QuizSelectionScreen extends StatelessWidget {
  final String uid;
  final UserService _userService = UserService();

  QuizSelectionScreen({super.key, required this.uid});

  Future<Map<String, dynamic>> getProgress(String collectionName) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final totalQuestions = (await firestore.collection('quiz').doc(collectionName).get()).data()?.length ?? 0;
    final completedQuestions = (await firestore.collection('user_progress').doc(collectionName).get()).data()?['completed'] ?? 0;
    return {
      'total': totalQuestions,
      'completed': completedQuestions,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '퀴즈 선택',
          style: TextStyle(color: Colors.black),
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
              List<Future<Map<String, dynamic>?>> progressFutures = quizCollections.map((quiz) {
                var quizId = quiz.id;
                return _userService.getQuizProgress(uid, quizId);
              }).toList();

              return FutureBuilder<List<Map<String, dynamic>?>>(
                future: Future.wait(progressFutures),
                builder: (context, progressSnapshots) {
                  if (progressSnapshots.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<Widget> completedQuizzes = [];
                  List<Widget> incompleteQuizzes = [];

                  for (var i = 0; i < quizCollections.length; i++) {
                    var quiz = quizCollections[i];
                    var progress = progressSnapshots.data?[i];
                    var data = quiz.data() as Map<String, dynamic>;
                    var quizId = quiz.id;
                    var score = progress != null ? (progress['score'] ?? 0) : 0;
                    var totalQuestions = progress != null ? (progress['totalQuestions'] ?? 10) : 10;
                    var isCompleted = progress != null ? score >= totalQuestions * 0.9 : false;

                    var quizCard = isCompleted
                        ? Stack(
                      children: [
                        Card(
                          color: Colors.orange[100],
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        quizId,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        data['catchphrase'] ?? '설명 없음',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircularScoreIndicator(
                            score: score,
                            totalQuestions: totalQuestions,
                            isCompleted: isCompleted,
                          ),
                        ),
                      ],
                    )
                        : FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: Card(
                        color: Colors.primaries[i % Colors.primaries.length][100],
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      quizId,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      data['catchphrase'] ?? '설명 없음',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      back: Card(
                        color: Colors.primaries[i % Colors.primaries.length][100],
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularScoreIndicator(
                                    score: score,
                                    totalQuestions: totalQuestions,
                                    isCompleted: isCompleted,
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizScreen(collectionName: quizId, uid: uid),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    '다시 풀어보기',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    if (isCompleted) {
                      completedQuizzes.add(quizCard);
                    } else {
                      incompleteQuizzes.add(quizCard);
                    }
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 2 / 3,
                    children: incompleteQuizzes + completedQuizzes,
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

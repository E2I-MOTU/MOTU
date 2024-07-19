import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_screen.dart';

class QuizSelectionScreen extends StatelessWidget {
  const QuizSelectionScreen({super.key});

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

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: quizCollections.length,
                itemBuilder: (context, index) {
                  var quiz = quizCollections[index];
                  var data = quiz.data() as Map<String, dynamic>;
                  var quizId = quiz.id;

                  return FutureBuilder(
                    future: getProgress(quizId),
                    builder: (context, progressSnapshot) {
                      if (progressSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final progress = progressSnapshot.data ?? {'total': 0, 'completed': 0};

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(collectionName: quizId),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.primaries[index % Colors.primaries.length][100],
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
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '${progress['completed']} / ${progress['total']}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

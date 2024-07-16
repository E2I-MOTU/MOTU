import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_screen.dart';
import 'test_skill_screen.dart';

class QuizSelectionScreen extends StatelessWidget {
  final List<Map<String, String>> quizCollections = [
    {
      'id': 'stock_market_terms_quiz',
      'title': '투자하려는 회사,\n믿을만한 지 어떻게\n판단할까요?',
      'subtitle': '재무제표 용어'
    },
    {
      'id': 'financial_market_terms_quiz',
      'title': '주식, 채권, 펀드\n어떻게 다른걸까요?',
      'subtitle': '금융 시장 용어'
    },
    {
      'id': 'quiz_question',
      'title': '경제는 무엇이고,\n경제는 어떻게\n돌아가는 걸까요?',
      'subtitle': '경제 기본 용어'
    },
    {
      'id': 'economics_terms_quiz',
      'title': '경제는 무엇이고,\n경제는 어떻게\n돌아가는 걸까요?',
      'subtitle': '주식 용어'
    },
  ];

  QuizSelectionScreen({super.key});

  Future<Map<String, dynamic>> getProgress(String collectionName) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final totalQuestions =
        (await firestore.collection(collectionName).get()).docs.length;
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '퀴즈 선택',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 2 / 3,
            ),
            itemCount: quizCollections.length,
            itemBuilder: (context, index) {
              final quiz = quizCollections[index];
              return FutureBuilder(
                future: getProgress(quiz['id']!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final progress =
                      snapshot.data ?? {'total': 0, 'completed': 0};

                  return Card(
                    color: Colors.primaries[index % Colors.primaries.length]
                        [100],
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  quiz['title']!,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  quiz['subtitle']!,
                                  style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        QuizScreen(collectionName: quiz['id']!),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                '경제 기본 배워보기',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TestSkillScreen(
                                        collectionName: quiz['id']!),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                '테스트로 실력 확인하기',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '${progress['completed']} / ${progress['total']}',
                              style: const TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
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

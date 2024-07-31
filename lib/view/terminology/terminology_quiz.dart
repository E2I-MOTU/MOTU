import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/terminology_quiz_provider.dart';
import 'terminology_incorrect_answers_screen.dart';

class TermQuizScreen extends StatelessWidget {
  final String collectionName;
  final String documentName;
  final String uid;

  const TermQuizScreen({Key? key, required this.collectionName, required this.documentName, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TerminologyQuizService()..loadQuestions(collectionName, documentName, uid),
      child: Consumer<TerminologyQuizService>(
        builder: (context, quizState, child) {
          if (quizState.isLoading) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text(
                  '퀴즈 앱',
                  style: TextStyle(color: Colors.black),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (quizState.currentQuestionIndex >= quizState.questions.length) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text(
                  '퀴즈 앱',
                  style: TextStyle(color: Colors.black),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('퀴즈 완료! 점수: ${quizState.score}/${quizState.questions.length}'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermIncorrectAnswersScreen(
                              termIncorrectAnswers: quizState.incorrectAnswers,
                            ),
                          ),
                        ).then((_) => Navigator.pop(context));
                      },
                      child: const Text('오답 확인'),
                    ),
                  ],
                ),
              ),
            );
          }

          final question = quizState.questions[quizState.currentQuestionIndex];

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                '퀴즈 앱',
                style: TextStyle(color: Colors.black),
              ),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          question['situation'] ?? '상황 설명이 없습니다.',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          question['question'] ?? '질문이 없습니다.',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (question['type'] == '단답형') ...[
                        TextField(
                          controller: quizState.answerController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '정답 입력',
                          ),
                          onChanged: (value) {
                            quizState.selectAnswer(value);
                          },
                        ),
                        const SizedBox(height: 20),
                      ] else if (question['type'] == '객관식') ...[
                        ...(question['options'] as List<dynamic>).map<Widget>((option) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: quizState.answered
                                    ? null
                                    : () {
                                  quizState.selectAnswer(option as String);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: quizState.selectedAnswer == option
                                      ? Colors.deepPurpleAccent
                                      : null,
                                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                child: Text(option as String),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: quizState.selectedAnswer.isEmpty
                            ? null
                            : () {
                          quizState.submitAnswer(question['answer'] ?? '');
                          quizState.nextQuestion();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text('제출'),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Text(
                    '${quizState.currentQuestionIndex + 1} / ${quizState.questions.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

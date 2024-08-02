import 'package:flutter/material.dart';
import 'package:motu/view/quiz/widget/linear_indicator.dart';
import 'package:provider/provider.dart';
import '../../provider/quiz_provider.dart';
import '../../widget/quiz_question.dart';
import 'incorrect_answers_screen.dart';

class QuizScreen extends StatelessWidget {
  final String collectionName;
  final String uid;

  const QuizScreen({super.key, required this.collectionName, required this.uid});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizService()..loadQuestions(collectionName),
      child: Consumer<QuizService>(
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
                            builder: (context) => IncorrectAnswersScreen(incorrectAnswers: quizState.incorrectAnswers),
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
            body: Column(
              children: [
                LinearIndicator(
                  current: quizState.currentQuestionIndex + 1,
                  total: quizState.questions.length,
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QuizQuestionWidget(
                          question: question['question'] ?? '질문이 없습니다.',
                          options: question['options'] ?? [],
                          selectedAnswer: quizState.selectedAnswer,
                          answered: quizState.answered,
                          onSelectAnswer: (String option) {
                            quizState.selectAnswer(option);
                          },
                          onSubmit: () {
                            quizState.submitAnswer(question['answer'] ?? '');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(quizState.correct ? '정답입니다!' : '오답입니다.'),
                                  content: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: Text(quizState.correct
                                        ? '잘했어요!'
                                        : '정답은 ${question['answer']} 입니다.'),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('다음 질문'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        quizState.nextQuestion(uid, collectionName);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          currentQuestionIndex: quizState.currentQuestionIndex + 1,
                          totalQuestions: quizState.questions.length,
                          isShortAnswer: false,
                        ),
                      ],
                    ),
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

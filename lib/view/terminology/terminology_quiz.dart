import 'package:flutter/material.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';
import '../../provider/terminology_quiz_provider.dart';
import '../../widget/quiz_question.dart';
import '../../widget/linear_indicator.dart';
import '../quiz/widget/circle_indicator.dart'; // Ensure this import path is correct
import 'terminology_incorrect_answers_screen.dart';

class TermQuizScreen extends StatelessWidget {
  final String collectionName;
  final String documentName;
  final String uid;

  const TermQuizScreen({
    Key? key,
    required this.collectionName,
    required this.documentName,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TerminologyQuizService()
        ..loadQuestions(collectionName, documentName, uid),
      child: Consumer<TerminologyQuizService>(
        builder: (context, quizState, child) {
          if (quizState.isLoading) {
            return Scaffold(
              backgroundColor: ColorTheme.colorNeutral,
              appBar: AppBar(
                backgroundColor: ColorTheme.colorWhite,
                title: const Text(
                  '용어 테스트',
                  style: TextStyle(color: Colors.black),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          bool isCompleted = quizState.score >= quizState.questions.length * 0.9;

          if (quizState.currentQuestionIndex >= quizState.questions.length) {
            return Scaffold(
              backgroundColor: ColorTheme.colorWhite,
              appBar: AppBar(
                backgroundColor: ColorTheme.colorWhite,
                title: const Text(
                  '용어 테스트',
                  style: TextStyle(color: Colors.black),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '테스트 응시 완료!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.5,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ColorTheme.colorNeutral,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4), // Shadow position
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 60),
                            Transform.scale(
                              scale: 3, // Scale factor for enlarging the indicator
                              child: CircularScoreIndicator(
                                score: quizState.score,
                                totalQuestions: quizState.questions.length,
                                isCompleted: isCompleted,
                              ),
                            ),
                            SizedBox(height: 80), // Adjusted spacing between elements
                            Image.asset(
                              'assets/images/panda.png',
                              width: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorTheme.colorPrimary,
                          foregroundColor: ColorTheme.colorWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        child: Text('틀린 문제 보러가기'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final question = quizState.questions[quizState.currentQuestionIndex];

          return Scaffold(
            backgroundColor: ColorTheme.colorNeutral,
            appBar: AppBar(
              backgroundColor: ColorTheme.colorWhite,
              title: const Text(
                '용어 테스트',
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
                      final contentHeight = constraints.maxHeight;

                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: contentHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                QuizQuestionWidget(
                                  question: question['question'] ?? '질문이 없습니다.',
                                  options: question['type'] == '객관식' ? question['options'] ?? [] : null,
                                  selectedAnswer: quizState.selectedAnswer,
                                  answered: quizState.answered,
                                  onSelectAnswer: (String option) {
                                    quizState.selectAnswer(option);
                                  },
                                  onSubmit: () {
                                    quizState.submitAnswer(question['answer'] ?? '');
                                    quizState.nextQuestion();
                                  },
                                  currentQuestionIndex: quizState.currentQuestionIndex + 1,
                                  totalQuestions: quizState.questions.length,
                                  isShortAnswer: question['type'] == '단답형',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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

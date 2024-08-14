import 'package:flutter/material.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';
import '../../provider/terminology_quiz_provider.dart';
import '../../text_utils.dart';
import '../../widget/quiz_question.dart';
import '../../widget/linear_indicator.dart';
import 'term_quiz_completed_screen.dart';

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

          if (quizState.currentQuestionIndex >= quizState.questions.length) {
            return TermQuizCompletedScreen(
              score: quizState.score,
              totalQuestions: quizState.questions.length,
              incorrectAnswers: quizState.incorrectAnswers,
              uid: uid,
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
                      final contentHeight = constraints.maxHeight;

                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: contentHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: contentHeight * 0.10),
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(24.0),
                                        decoration: BoxDecoration(
                                          color: ColorTheme.colorWhite,
                                          border: Border.all(
                                            color: ColorTheme.colorPrimary,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          preventWordBreak(question['situation'] ?? '상황 설명이 없습니다.'),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Positioned(
                                        top: -15,
                                        left: -10,
                                        child: ClipPath(
                                          clipper: ArrowClipper(),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                                            color: ColorTheme.colorPrimary,
                                            child: Transform.translate(
                                              offset: Offset(-4, 0),
                                              child: const Text(
                                                '상황',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                QuizQuestionWidget(
                                  question: preventWordBreak(question['question'] ?? '질문이 없습니다.'),
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
                                  answerController: quizState.answerController,
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

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 20, 0); // Top-right corner minus triangle width
    path.lineTo(size.width, size.height / 2); // Midpoint of right edge
    path.lineTo(size.width - 20, size.height); // Bottom-right corner minus triangle width
    path.lineTo(0, size.height); // Bottom-left corner
    path.lineTo(0, 0); // Top-left corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

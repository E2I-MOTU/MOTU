import 'package:flutter/material.dart';
import 'package:motu/widget/linear_indicator.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';
import '../../provider/quiz_provider.dart';
import '../../text_utils.dart';
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
              backgroundColor: ColorTheme.colorNeutral,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text(
                  '용어 퀴즈',
                  style: TextStyle(color: Colors.black),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (quizState.currentQuestionIndex >= quizState.questions.length) {
            return Scaffold(
              backgroundColor: ColorTheme.colorNeutral,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text(
                  '용어 퀴즈',
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
          bool isHintVisible = quizState.isHintVisible;

          return Scaffold(
            backgroundColor: ColorTheme.colorNeutral,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                '용어 퀴즈',
                style: TextStyle(color: Colors.black),
              ),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    LinearIndicator(
                      current: quizState.currentQuestionIndex + 1,
                      total: quizState.questions.length,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            if (isHintVisible)
                              Positioned(
                                top: 30,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    question['hint'] ?? '힌트가 없습니다.',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            TextButton(
                              onPressed: () {
                                quizState.toggleHintVisibility();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(80, 30),
                                backgroundColor: isHintVisible ? ColorTheme.colorPrimary : Colors.transparent,
                                side: isHintVisible
                                    ? BorderSide.none
                                    : BorderSide(color: ColorTheme.colorDisabled),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                foregroundColor: isHintVisible ? Colors.white : ColorTheme.colorDisabled,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                width: 80,
                                height: 30,
                                child: const Text(
                                  'Hint 보기',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                preventWordBreak(question['question'] ?? '질문이 없습니다.'),
                                style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...(question['options'] as List<dynamic>).map<Widget>((option) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: ElevatedButton(
                                    onPressed: quizState.answered
                                        ? null
                                        : () {
                                      quizState.selectAnswer(option as String);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shadowColor: Colors.transparent,
                                      backgroundColor: quizState.selectedAnswer == option
                                          ? ColorTheme.colorPrimary
                                          : ColorTheme.colorWhite,
                                      foregroundColor: quizState.selectedAnswer == option
                                          ? ColorTheme.colorWhite
                                          : ColorTheme.colorFont,
                                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      preventWordBreak(option as String),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: quizState.selectedAnswer.isEmpty
                                        ? null
                                        : () {
                                      quizState.submitAnswer(question['answer'] ?? '');
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(quizState.correct
                                                ? '정답입니다!'
                                                : '오답입니다.'),
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
                                                  quizState.nextQuestion(
                                                      uid, collectionName);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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

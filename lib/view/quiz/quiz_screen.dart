import 'package:flutter/material.dart';
import 'package:motu/widget/linear_indicator.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';
import '../../provider/quiz_provider.dart';
import '../../text_utils.dart';
import 'incorrect_answers_screen.dart';
import 'quiz_completed_screen.dart';

class QuizScreen extends StatefulWidget {
  final String collectionName;
  final String uid;

  const QuizScreen({super.key, required this.collectionName, required this.uid});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  OverlayEntry? _overlayEntry;
  bool _submitted = false;

  void _showAnswerPopup(bool correct, String selectedAnswer, String correctAnswer) {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 250,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/panda.png',
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      correct ? '정답입니다!' : '오답입니다.',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      correct ? '잘했어요!' : '정답은 ${preventWordBreak(correctAnswer)} 입니다.',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
        setState(() {
          _submitted = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizService()..loadQuestions(widget.collectionName),
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
                    Text(
                      '퀴즈 완료! 점수: ${quizState.score}/${quizState.questions.length}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizCompletedScreen(
                              score: quizState.score,
                              totalQuestions: quizState.questions.length,
                              incorrectAnswers: quizState.incorrectAnswers,
                              uid: widget.uid,
                            ),
                          ),
                        ).then((_) => Navigator.pop(context));
                      },
                      child: const Text('점수 보기'),
                    ),
                  ],
                ),
              ),
            );
          }

          final question = quizState.questions[quizState.currentQuestionIndex];
          bool isHintVisible = quizState.isHintVisible;
          String selectedAnswer = quizState.selectedAnswer;
          bool correct = selectedAnswer == question['answer'];

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
                                  child: AbsorbPointer(
                                    absorbing: _submitted, // Absorb touches if submitted
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (!_submitted) {
                                          quizState.selectAnswer(option as String);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.transparent,
                                        backgroundColor: _submitted
                                            ? (quizState.selectedAnswer == option
                                            ? (quizState.selectedAnswer == question['answer']
                                            ? ColorTheme.colorPrimary
                                            : ColorTheme.colorDisabled)
                                            : (option == question['answer']
                                            ? ColorTheme.colorPrimary
                                            : ColorTheme.colorWhite))
                                            : (quizState.selectedAnswer == option
                                            ? ColorTheme.colorPrimary
                                            : ColorTheme.colorWhite), // Submit not clicked yet
                                        foregroundColor: _submitted
                                            ? (quizState.selectedAnswer == option
                                            ? (quizState.selectedAnswer == question['answer']
                                            ? Colors.white
                                            : Colors.black)
                                            : (option == question['answer']
                                            ? Colors.white
                                            : ColorTheme.colorFont))
                                            : (quizState.selectedAnswer == option
                                            ? Colors.white
                                            : ColorTheme.colorFont), // Submit not clicked yet
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
                                ),
                              );
                            }).toList(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: 150,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (_submitted)
                                        SizedBox(
                                          width: 150,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (quizState.currentQuestionIndex + 1 >= quizState.questions.length) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => QuizCompletedScreen(
                                                      score: quizState.score,
                                                      totalQuestions: quizState.questions.length,
                                                      incorrectAnswers: quizState.incorrectAnswers,
                                                      uid: widget.uid,
                                                    ),
                                                  ),
                                                ).then((_) => Navigator.pop(context));
                                              } else {
                                                setState(() {
                                                  _submitted = false; // Reset state to allow selection
                                                  quizState.selectAnswer(''); // Clear selected answer
                                                  Provider.of<QuizService>(context, listen: false).nextQuestion(widget.uid, widget.collectionName);
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              backgroundColor: ColorTheme.colorPrimary,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: Text(
                                              quizState.currentQuestionIndex + 1 >= quizState.questions.length
                                                  ? '점수 보기'
                                                  : '다음 문제',
                                            ),
                                          ),
                                        )
                                      else
                                        SizedBox(
                                          width: 150,
                                          child: ElevatedButton(
                                            onPressed: quizState.selectedAnswer.isEmpty
                                                ? null
                                                : () {
                                              bool correct = quizState.selectedAnswer == question['answer'];
                                              quizState.submitAnswer(question['answer'] ?? ''); // Submit answer and update score
                                              _showAnswerPopup(correct, quizState.selectedAnswer, question['answer'] ?? '');
                                              setState(() {
                                                _submitted = true; // Update state to show the next question button
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              backgroundColor: ColorTheme.colorPrimary,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('제출'),
                                          ),
                                        ),
                                    ],
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

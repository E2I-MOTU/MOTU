import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/quiz_provider.dart';
import '../../text_utils.dart';
import '../../widget/linear_indicator.dart';
import '../theme/color_theme.dart';
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
      builder: (context) {

        return Stack(
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
                  width: 200,
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
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        correct ? '잘했어요!' : '정답은 ${preventWordBreak(correctAnswer)} 입니다.',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
                  '경제/금융 퀴즈',
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
                  '경제/금융 퀴즈',
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

          final screenWidth = MediaQuery.of(context).size.width;
          final maxWidth = screenWidth * 0.9;

          return Scaffold(
            backgroundColor: ColorTheme.colorNeutral,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                '경제/금융 퀴즈',
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
                      padding: const EdgeInsets.all(16.0),
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
                                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
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
                              child: Center(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        return Container(
                                          constraints: BoxConstraints(
                                            maxWidth: maxWidth,
                                          ),
                                          padding: const EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: ColorTheme.colorPrimary,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              preventWordBreak(question['question'] ?? '질문이 없습니다.'),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Positioned(
                                      top: -15,
                                      left: -10,
                                      child: ClipPath(
                                        clipper: ArrowClipper(),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                                          color: ColorTheme.colorPrimary,
                                          child: Transform.translate(
                                            offset: Offset(-4, 0),
                                            child: const Text(
                                              'Q.',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ...question['options']!.map<Widget>((option) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: SizedBox(
                                  width: maxWidth,
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
                                          : ColorTheme.colorWhite),
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
                                          : ColorTheme.colorFont),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (_submitted)
                                        SizedBox(
                                          width: 120,
                                          height: 50,
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
                                                  _submitted = false;
                                                  quizState.selectAnswer('');
                                                  Provider.of<QuizService>(context, listen: false).nextQuestion(widget.uid, widget.collectionName);
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(10.0),
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
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
                                          width: 120,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: quizState.selectedAnswer.isEmpty
                                                ? null
                                                : () {
                                              bool correct = quizState.selectedAnswer == question['answer'];
                                              quizState.submitAnswer(question['answer'] ?? '');
                                              _showAnswerPopup(correct, quizState.selectedAnswer, question['answer'] ?? '');
                                              setState(() {
                                                _submitted = true;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(10.0),
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                              ),
                                              backgroundColor: ColorTheme.colorPrimary,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('정답 확인'),
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

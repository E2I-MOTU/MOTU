import 'package:flutter/material.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:motu/view/quiz/widget/circle_indicator.dart';
import 'terminology_incorrect_answers_screen.dart';
import 'package:speech_balloon/speech_balloon.dart';

class TermQuizCompletedScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<Map<String, dynamic>> incorrectAnswers;

  const TermQuizCompletedScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.incorrectAnswers,
  }) : super(key: key);

  String getFeedbackMessage() {
    double percentage = (score / totalQuestions) * 100;

    if (percentage < 50) {
      return '공부를 다시 해봐야겠어요';
    } else if (percentage >= 50 && percentage < 90) {
      return '잘했어요! 조금만 더 공부하면 되겠는걸요?';
    } else if (percentage >= 90 && percentage < 100) {
      return '정말 잘했어요!';
    } else {
      return '완벽해요!';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = score >= totalQuestions * 0.9;

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
                        score: score,
                        totalQuestions: totalQuestions,
                        isCompleted: isCompleted,
                      ),
                    ),
                    SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/panda.png',
                          width: 100,
                        ),
                        SizedBox(width: 20),
                        SpeechBalloon(
                          nipLocation: NipLocation.left,
                          color: ColorTheme.colorPrimary,
                          width: 160,
                          height: 50,
                          borderRadius: 10,
                          child: Center( // Center widget 추가
                            child: Text(
                              getFeedbackMessage(),
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorTheme.colorWhite,
                              ),
                              textAlign: TextAlign.center, // 텍스트 중앙 정렬
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
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
                        termIncorrectAnswers: incorrectAnswers,
                      ),
                    ),
                  ).then((_) => Navigator.pop(context));
                },
                child: Text('틀린 문제 보러가기'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorTheme.colorDisabled,
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
                  /*
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermMain(), // TermMain 페이지로 이동
                    ),
                    (route) => false, // 모든 기존 경로를 제거
                  );
                  */
                },
                child: Text('종료하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

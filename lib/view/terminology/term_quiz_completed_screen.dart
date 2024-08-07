import 'package:flutter/material.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:motu/view/quiz/widget/circle_indicator.dart'; // Ensure this import path is correct
import 'terminology_incorrect_answers_screen.dart';

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
                        score: score,
                        totalQuestions: totalQuestions,
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
                        termIncorrectAnswers: incorrectAnswers,
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
}

import 'package:flutter/material.dart';
import '../../theme/color_theme.dart';
import '../term_quiz.dart';

Widget buildCompletionPage(BuildContext context, String title, String documentName, String uid) {
  final double buttonWidth = MediaQuery.of(context).size.width * 0.8; // Set button width to 80% of screen width
  final double buttonHeight = 60;

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '학습 완료!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 40),
        Image.asset(
          'assets/images/panda.png',
          height: 200,
          width: 200,
        ),
        SizedBox(height: 40),
        Text(
          '축하합니다! 모든 카드를 학습하셨습니다. \n 테스트를 통과하고 수료까지 해보세요!',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 60),
        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorTheme.colorPrimary, // Set button color
              foregroundColor: ColorTheme.colorWhite, // Set text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Set radius
              ),
              textStyle: TextStyle(
                fontSize: 20, // Increase font size
                fontWeight: FontWeight.bold, // Make font bold
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermQuizScreen(
                    collectionName: 'terminology',
                    documentName: documentName,
                    uid: uid,
                  ),
                ),
              );
            },
            child: Text('테스트 응시'),
          ),
        ),
      ],
    ),
  );
}
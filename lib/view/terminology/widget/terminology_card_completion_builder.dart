import 'package:flutter/material.dart';
import '../../theme/color_theme.dart';
import '../term_quiz.dart';

Widget buildCompletionPage(BuildContext context, String title, String documentName, String uid) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  final double containerWidth = screenWidth * 0.9;
  final double containerHeight = screenHeight * 0.52;
  final double buttonWidth = screenWidth * 0.8;
  final double buttonHeight = 60;

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: containerWidth,
            height: containerHeight,
            padding: const EdgeInsets.all(20), // Add padding around the container
            decoration: BoxDecoration(
              color: Colors.white, // Set background color to white
              borderRadius: BorderRadius.circular(20), // Set border radius for rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '학습 완료!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20), // Reduced space between title and image
                Image.asset(
                  'assets/images/character/complete_panda.png',
                  width: 240,
                ),
                SizedBox(height: 20), // Reduced space between image and text
                Text(
                  '축하합니다! 모든 카드를 학습하셨습니다. \n 테스트를 통과하고 수료까지 해보세요!',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
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

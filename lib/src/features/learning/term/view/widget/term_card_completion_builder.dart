import 'package:flutter/material.dart';
import 'package:motu/src/features/learning/term/view/term_quiz_page.dart';
import '../../../../../design/color_theme.dart';

Widget TermCardCompletionBuilder(
    BuildContext context, String title, String documentName, String uid) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  final double containerWidth = screenWidth * 0.9;
  final double containerHeight = screenHeight * 0.52;
  final double buttonWidth = screenWidth * 0.8;
  const double buttonHeight = 60;

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: containerWidth,
            height: containerHeight,
            decoration: BoxDecoration(
              color: Colors.white, // Set background color to white
              borderRadius: BorderRadius.circular(
                  20), // Set border radius for rounded corners
              boxShadow: const [
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
                const Text(
                  '학습 완료!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                    height: 20), // Reduced space between title and image
                Image.asset(
                  'assets/images/character/complete_panda.png',
                  width: 240,
                ),
                const SizedBox(
                    height: 20), // Reduced space between image and text
                const Text(
                  '축하합니다! 모든 카드를 학습하셨습니다. \n 테스트를 통과하고 수료까지 해보세요!',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
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
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermQuizPage(
                    collectionName: 'terminology',
                    documentName: documentName,
                    uid: uid,
                  ),
                ),
              );
            },
            child: const Text('테스트 응시'),
          ),
        ),
      ],
    ),
  );
}

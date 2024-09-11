import 'package:flutter/material.dart';
import '../../../text_utils.dart';
import '../../theme/color_theme.dart';
import '../quiz_screen.dart';
import 'circle_indicator.dart';

String formatQuizId(String quizId) {
  int maxLength = 9;
  if (quizId.length <= maxLength) return quizId;

  StringBuffer formattedId = StringBuffer();
  for (int i = 0; i < quizId.length; i += maxLength) {
    if (i + maxLength < quizId.length) {
      formattedId.write(quizId.substring(i, i + maxLength) + '\n');
    } else {
      formattedId.write(quizId.substring(i));
    }
  }
  return formattedId.toString();
}

Widget buildQuizCard({
  required BuildContext context,
  required String uid,
  required String quizId,
  required String catchphrase,
  required int score,
  required int totalQuestions,
  required bool isCompleted,
  required bool isNewQuiz,
}) {
  return Stack(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage('assets/images/quiz_background.png'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      formatQuizId(quizId),
                      style: const TextStyle(
                        fontSize: 15,
                        color: ColorTheme.colorWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        preventWordBreak(catchphrase),
                        style: const TextStyle(
                          fontSize: 12,
                          color: ColorTheme.colorWhite,
                        ),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(collectionName: quizId, uid: uid),
                      ),
                    );
                  },
                  child: const Text('풀어보자'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme.colorWhite,
                    foregroundColor: ColorTheme.colorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      if (isCompleted)
        Positioned(
          top: 10,
          right: 10,
          child: Image.asset(
            'assets/images/medal.png',
            width: 40,
            height: 40,
          ),
        )
      else if (score > 0 && totalQuestions > 0)
        Positioned(
          top: 10,
          right: 10,
          child: CircularScoreIndicator(
            score: score,
            totalQuestions: totalQuestions,
            isCompleted: isCompleted,
            width: 40,
            height: 40,
            strokeWidth: 4,
          ),
        ),
    ],
  );
}


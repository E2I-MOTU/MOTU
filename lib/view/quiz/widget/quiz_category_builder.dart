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
          color: isCompleted
              ? Colors.orange[100]
              : Colors.primaries[quizId.hashCode % Colors.primaries.length][100],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 4),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      formatQuizId(quizId),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                    child: Text(
                      preventWordBreak(catchphrase),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
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

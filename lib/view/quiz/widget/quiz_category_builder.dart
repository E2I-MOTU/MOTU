import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:motu/text_utils.dart';
import '../quiz_screen.dart';
import 'circle_indicator.dart';

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
  var flipCardController = FlipCardController();

  Widget buildCardContent(String buttonText, VoidCallback onPressed) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  quizId,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  preventWordBreak(catchphrase),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(buttonText, style: const TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  return isCompleted
      ? Stack(
    children: [
      Card(
        color: Colors.orange[100],
        child: buildCardContent('복습하기', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(collectionName: quizId, uid: uid),
            ),
          );
        }),
      ),
      Positioned(
        top: 8,
        right: 8,
        child: CircularScoreIndicator(
          score: score,
          totalQuestions: totalQuestions,
          isCompleted: isCompleted,
        ),
      ),
    ],
  )
      : isNewQuiz
      ? Card(
    color: Colors.primaries[quizId.hashCode % Colors.primaries.length][100],
    child: buildCardContent('배워보자', () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(collectionName: quizId, uid: uid),
        ),
      );
    }),
  )
      : FlipCard(
    controller: flipCardController,
    direction: FlipDirection.HORIZONTAL,
    front: Card(
      color: Colors.primaries[quizId.hashCode % Colors.primaries.length][100],
      child: buildCardContent('점수보기', () {
        flipCardController.toggleCard();
      }),
    ),
    back: Card(
      color: Colors.primaries[quizId.hashCode % Colors.primaries.length][100],
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularScoreIndicator(
                  score: score,
                  totalQuestions: totalQuestions,
                  isCompleted: isCompleted,
                  width: 120,
                  height: 120,
                  strokeWidth: 20,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(collectionName: quizId, uid: uid),
                    ),
                  );
                },
                child: const Text(
                  '다시 풀어보기',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

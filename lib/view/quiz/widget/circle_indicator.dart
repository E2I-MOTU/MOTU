import 'package:flutter/material.dart';

class CircularScoreIndicator extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final bool isCompleted;

  const CircularScoreIndicator({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = score / totalQuestions;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!isCompleted)
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              value: percentage,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              strokeWidth: 6,
            ),
          ),
        if (isCompleted)
          const Icon(
            Icons.emoji_events,
            color: Colors.orange,
            size: 30,
          )
        else
          Text(
            '$score/$totalQuestions',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
      ],
    );
  }
}

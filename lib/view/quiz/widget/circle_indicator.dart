import 'package:flutter/material.dart';

class CircularScoreIndicator extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final bool isCompleted;
  final double width;
  final double height;
  final double strokeWidth;

  const CircularScoreIndicator({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.isCompleted,
    this.width = 50.0,
    this.height = 50.0,
    this.strokeWidth = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = score / totalQuestions;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!isCompleted)
          SizedBox(
            width: width,
            height: height,
            child: CircularProgressIndicator(
              value: percentage,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
              strokeWidth: strokeWidth,
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

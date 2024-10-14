import 'package:flutter/material.dart';
import '../../../../../../design/color_theme.dart';

class CircularScoreIndicator extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final bool isCompleted;
  final double width;
  final double height;
  final double strokeWidth;

  const CircularScoreIndicator({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.isCompleted,
    this.width = 50.0,
    this.height = 50.0,
    this.strokeWidth = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: CircularProgressIndicator(
            value: score / totalQuestions,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted ? Colors.orange : ColorTheme.colorPrimary,
            ),
            strokeWidth: strokeWidth,
          ),
        ),
        Text(
          '$score/$totalQuestions',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isCompleted ? Colors.orange : ColorTheme.colorPrimary,
          ),
        ),
      ],
    );
  }
}

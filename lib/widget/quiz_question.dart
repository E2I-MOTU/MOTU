import 'package:flutter/material.dart';
import 'package:motu/view/theme/color_theme.dart';

class QuizQuestionWidget extends StatelessWidget {
  final String question;
  final List<dynamic>? options;
  final String selectedAnswer;
  final bool answered;
  final Function(String) onSelectAnswer;
  final Function onSubmit;
  final int currentQuestionIndex;
  final int totalQuestions;
  final bool isShortAnswer;

  const QuizQuestionWidget({
    Key? key,
    required this.question,
    this.options,
    required this.selectedAnswer,
    required this.answered,
    required this.onSelectAnswer,
    required this.onSubmit,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    this.isShortAnswer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isShortAnswer)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: TextField(
                  onChanged: onSelectAnswer,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '정답 입력',
                  ),
                ),
              )
            else if (options != null)
              ...(options!).map<Widget>((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: answered
                          ? null
                          : () {
                        onSelectAnswer(option as String);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedAnswer == option
                            ? ColorTheme.colorPrimary
                            : ColorTheme.colorWhite,
                        foregroundColor: selectedAnswer == option
                            ? ColorTheme.colorWhite
                            : ColorTheme.colorFont,
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(option as String),
                    ),
                  ),
                );
              }).toList(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                onSubmit();
              },
              child: const Text(
                '다음 문제로 넘어가기',
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

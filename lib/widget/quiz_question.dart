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
  final TextEditingController answerController;

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
    required this.answerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                textAlign: TextAlign.left, // Ensure left alignment of text
              ),
            ),
            if (isShortAnswer)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  width: screenWidth * 0.9,
                  child: TextField(
                    controller: answerController,
                    onChanged: (text) {
                      onSelectAnswer(text);
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorTheme.colorWhite,
                      hintText: '정답 입력',
                      hintStyle: TextStyle(
                        color: ColorTheme.colorDisabled,
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                    ),
                  ),
                ),
              )
            else if (options != null)
              ...(options!).map<Widget>((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: SizedBox(
                    width: screenWidth * 0.9,
                    child: ElevatedButton(
                      onPressed: answered
                          ? null
                          : () {
                        onSelectAnswer(option as String);
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        backgroundColor: selectedAnswer == option
                            ? ColorTheme.colorPrimary
                            : ColorTheme.colorWhite,
                        foregroundColor: selectedAnswer == option
                            ? ColorTheme.colorWhite
                            : ColorTheme.colorFont,
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                      child: Text(
                        option as String,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                );
              }).toList(),
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
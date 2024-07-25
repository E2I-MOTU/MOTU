import 'package:flutter/material.dart';

class IncorrectAnswersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> incorrectAnswers;

  const IncorrectAnswersScreen({super.key, required this.incorrectAnswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오답 확인'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      body: PageView.builder(
        itemCount: incorrectAnswers.length,
        itemBuilder: (context, index) {
          final question = incorrectAnswers[index]['question'];
          final selectedAnswer = incorrectAnswers[index]['selectedAnswer'];
          final correctAnswer = incorrectAnswers[index]['correctAnswer'];
          final options = incorrectAnswers[index]['options'] as List<dynamic>;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.purple,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          question,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...options.map<Widget>((option) {
                        Color optionColor;
                        if (option == selectedAnswer) {
                          optionColor = Colors.red.withOpacity(0.7);
                        } else if (option == correctAnswer) {
                          optionColor = Colors.green.withOpacity(0.7);
                        } else {
                          optionColor = Colors.grey.withOpacity(0.3);
                        }
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          decoration: BoxDecoration(
                            color: optionColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            option,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

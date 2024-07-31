import 'package:flutter/material.dart';

class TerminologyIncorrectAnswersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> terminologyIncorrectAnswers;

  const TerminologyIncorrectAnswersScreen({super.key, required this.terminologyIncorrectAnswers});

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
        itemCount: terminologyIncorrectAnswers.length,
        itemBuilder: (context, index) {
          final question = terminologyIncorrectAnswers[index]['question'] ?? '질문이 없습니다.';
          final selectedAnswer = terminologyIncorrectAnswers[index]['selectedAnswer'] ?? '답변이 없습니다.';
          final correctAnswer = terminologyIncorrectAnswers[index]['correctAnswer'] ?? '정답이 없습니다.';
          final options = terminologyIncorrectAnswers[index]['options'] as List<dynamic>?;
          final type = terminologyIncorrectAnswers[index]['type'] ?? '타입이 없습니다.';
          final situation = terminologyIncorrectAnswers[index]['situation'] ?? '상황 설명이 없습니다.';

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
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          situation,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (type == '객관식' && options != null) ...[
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
                      ] else if (type == '단답형') ...[
                        const SizedBox(height: 20),
                        Text(
                          '사용자 답변: $selectedAnswer',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '정답: $correctAnswer',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
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

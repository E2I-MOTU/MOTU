import 'package:flutter/material.dart';
import 'package:motu/text_utils.dart';
import '../theme/color_theme.dart';
import '../../widget/linear_indicator.dart';

class IncorrectAnswersScreen extends StatefulWidget {
  final List<Map<String, dynamic>> incorrectAnswers;

  const IncorrectAnswersScreen({super.key, required this.incorrectAnswers});

  @override
  _IncorrectAnswersScreenState createState() => _IncorrectAnswersScreenState();
}

class _IncorrectAnswersScreenState extends State<IncorrectAnswersScreen> {
  PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  void _goToNextPage() {
    if (_currentPageIndex < widget.incorrectAnswers.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오답 확인'),
        backgroundColor: ColorTheme.colorNeutral,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      backgroundColor: ColorTheme.colorNeutral,
      body: Column(
        children: [
          LinearIndicator(
            current: _currentPageIndex + 1,
            total: widget.incorrectAnswers.length,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.incorrectAnswers.length,
              itemBuilder: (context, index) {
                final question = widget.incorrectAnswers[index]['question'] ?? '질문이 없습니다.';
                final selectedAnswer = widget.incorrectAnswers[index]['selectedAnswer'] ?? '답변이 없습니다.';
                final correctAnswer = widget.incorrectAnswers[index]['correctAnswer'] ?? '정답이 없습니다.';
                final options = widget.incorrectAnswers[index]['options'] as List<dynamic>?;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.close,
                          color: ColorTheme.colorPrimary,
                          size: 100,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          preventWordBreak(question),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        if (options != null) ...[
                          ...options.map<Widget>((option) {
                            Color optionColor = ColorTheme.colorWhite;
                            if (option == selectedAnswer) {
                              optionColor = ColorTheme.colorDisabled.withOpacity(0.7);
                            } else if (option == correctAnswer) {
                              optionColor = Colors.green.withOpacity(0.7);
                            } else {
                              optionColor = ColorTheme.colorWhite;
                            }
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20.0),
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                color: optionColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                option,
                                style: const TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }).toList(),
                        ],
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: _goToNextPage,
                          child: const Text(
                            '다음 틀린 문제 확인하기',
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

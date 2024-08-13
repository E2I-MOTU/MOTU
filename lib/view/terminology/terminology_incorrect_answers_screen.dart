import 'package:flutter/material.dart';
import 'package:motu/text_utils.dart';
import '../theme/color_theme.dart';
import '../../widget/linear_indicator.dart';

class TermIncorrectAnswersScreen extends StatefulWidget {
  final List<Map<String, dynamic>> termIncorrectAnswers;

  const TermIncorrectAnswersScreen({super.key, required this.termIncorrectAnswers});

  @override
  _TermIncorrectAnswersScreenState createState() => _TermIncorrectAnswersScreenState();
}

class _TermIncorrectAnswersScreenState extends State<TermIncorrectAnswersScreen> {
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
    if (_currentPageIndex < widget.termIncorrectAnswers.length - 1) {
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
            total: widget.termIncorrectAnswers.length,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.termIncorrectAnswers.length,
              itemBuilder: (context, index) {
                final question = widget.termIncorrectAnswers[index]['question'] ?? '질문이 없습니다.';
                final selectedAnswer = widget.termIncorrectAnswers[index]['selectedAnswer'] ?? '답변이 없습니다.';
                final correctAnswer = widget.termIncorrectAnswers[index]['correctAnswer'] ?? '정답이 없습니다.';
                final options = widget.termIncorrectAnswers[index]['options'] as List<dynamic>?;
                final type = widget.termIncorrectAnswers[index]['type'] ?? '타입이 없습니다.';
                final situation = widget.termIncorrectAnswers[index]['situation'] ?? '상황 설명이 없습니다.';

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
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24.0),
                                decoration: BoxDecoration(
                                  color: ColorTheme.colorWhite,
                                  border: Border.all(
                                    color: ColorTheme.colorPrimary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  preventWordBreak(situation),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Positioned(
                                top: -15,
                                left: -10,
                                child: ClipPath(
                                  clipper: ArrowClipper(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                                    color: ColorTheme.colorPrimary,
                                    child: Transform.translate(
                                      offset: Offset(-4, 0),
                                      child: const Text(
                                        '상황',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                        const SizedBox(height: 10),
                        if (type == '객관식' && options != null) ...[
                          ...options.map<Widget>((option) {
                            Color optionColor = ColorTheme.colorWhite;
                            if (option == selectedAnswer) {
                              optionColor = ColorTheme.colorDisabled.withOpacity(0.7);
                            } /*else if (option == correctAnswer) {
                              optionColor = Colors.green.withOpacity(0.7);
                            }*/
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
                        ] else if (type == '단답형') ...[
                          const SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 60,
                            decoration: BoxDecoration(
                              color: ColorTheme.colorDisabled.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '입력한 답변: $selectedAnswer',
                              style: TextStyle(
                                fontSize: 16,
                                color: ColorTheme.colorFont,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          /*Text(
                            '정답: $correctAnswer',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),*/
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

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 20, 0); // Top-right corner minus triangle width
    path.lineTo(size.width, size.height / 2); // Midpoint of right edge
    path.lineTo(size.width - 20, size.height); // Bottom-right corner minus triangle width
    path.lineTo(0, size.height); // Bottom-left corner
    path.lineTo(0, 0); // Top-left corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

import 'package:flutter/material.dart';
import 'package:motu/view/quiz/quiz.dart';
import 'package:motu/view/word/word_main.dart';
import '../news/news_list_screen.dart';
import 'chat_screen.dart';

class LearningContentscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Colors.green[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.1),
                const Text(
                  '오늘의 공부\n함께 시작해볼까요?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.red),
                      const SizedBox(width: 10),
                      const Text(
                        '일단 시작만 해도\n누구나 1% 포인트!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildCard(context, '용어 공부하기', Colors.deepPurpleAccent, WordsLearning()),
                _buildCard(context, '퀴즈 풀며\n내 실력 확인해보기', Colors.pinkAccent, QuizSelectionScreen()),
                _buildCard(context, '꼭 필요한 경제칼럼 읽으며\n경제지식 쌓기', Colors.orange, null),
                _buildCard(context, '오늘의 시사 정보 확인하기', Colors.cyan, NewsListScreen()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatbotScreen()),
          );
        },
        child: Icon(Icons.chat),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String text, Color color, Widget? nextScreen) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nextScreen != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nextScreen),
                );
              }
            },
            child: const Text('도전하기'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

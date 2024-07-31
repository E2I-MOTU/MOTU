import 'package:flutter/material.dart';
import 'package:motu/view/quiz/quiz.dart';
import 'package:motu/view/word/word_main.dart';
import '../article/article_list_screen.dart';
import '../news/news_list_screen.dart';
import '../theme/color_theme.dart';
import 'chat_screen.dart';

class LearningContentscreen extends StatelessWidget {
  final String uid;

  const LearningContentscreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, //그림자 X
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorTheme.colorFont),
          onPressed: () {

          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.search, color: ColorTheme.colorFont),
            onPressed: () {

            },
          ),
        ],
      ),
      backgroundColor: ColorTheme.colorNeutral,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              color: ColorTheme.colorSecondary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.07),
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
                    color: ColorTheme.colorSecondary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.red),
                      const SizedBox(width: 10),
                      const Text(
                        '일단 시작만 해도\n누구나 1% 포인트!',
                        style: TextStyle(
                          color: ColorTheme.colorWhite,
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
              padding: const EdgeInsets.all(15),
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
              childAspectRatio: 5 / 6,
              children: [
                _buildCard(context, '용어\n공부하기', ColorTheme.colorWhite, WordsMain()),
                _buildCard(context, '퀴즈 풀며\n내 실력\n확인해보기', ColorTheme.colorWhite, QuizSelectionScreen(uid: uid)),
                _buildCard(context, '꼭 필요한 경제칼럼\n읽으며\n경제지식 쌓기', ColorTheme.colorWhite, ArticleListScreen()),
                _buildCard(context, '오늘의\n시사 정보\n확인하기', ColorTheme.colorWhite, NewsListScreen()),
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
        backgroundColor: ColorTheme.colorPrimary, // 배경색 설정
        foregroundColor: Colors.white, // 아이콘 색상 설정
      ),
    );
  }

  Widget _buildCard(BuildContext context, String text, Color color, Widget? nextScreen) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // 그림자 색상
            spreadRadius: 2, // 그림자 확산 범위
            blurRadius: 2, // 그림자 흐림 반경
            offset: Offset(0, 4), // 그림자의 위치 (x, y)
          ),
        ],
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
                  color: ColorTheme.colorFont,
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
              backgroundColor: ColorTheme.colorSecondary,
              foregroundColor: ColorTheme.colorWhite,
              minimumSize: Size(140, 40), // 원하는 가로 길이와 세로 길이 설정
            ),
          )
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motu/view/learning/widget/learning_contents_builder.dart';
import 'package:motu/view/quiz/quiz_main.dart';
import 'package:motu/view/terminology/terminology_main.dart';
import '../../widget/drawer_menu.dart';
import '../article/article_list_screen.dart';
import '../news/news_list_screen.dart';
import '../theme/color_theme.dart';
import 'chat_screen.dart';

class LearningContentscreen extends StatelessWidget {

  const LearningContentscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      drawer: const DrawerMenu(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                SizedBox(height: appBarHeight + 40),
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
                buildCard(context, '용어\n공부하기', ColorTheme.colorWhite, TermMain(uid: auth.currentUser!.uid)),
                buildCard(context, '퀴즈 풀며\n내 실력\n확인해보기', ColorTheme.colorWhite, QuizSelectionScreen(uid: auth.currentUser!.uid)),
                buildCard(context, '꼭 필요한 경제칼럼\n읽으며\n경제지식 쌓기', ColorTheme.colorWhite, ArticleListScreen()),
                buildCard(context, '오늘의\n시사 정보\n확인하기', ColorTheme.colorWhite, NewsListScreen()),
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
        child: const Icon(Icons.chat),
        backgroundColor: ColorTheme.colorPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

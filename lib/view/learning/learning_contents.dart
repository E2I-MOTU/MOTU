import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motu/view/learning/widget/learning_contents_builder.dart';
import 'package:motu/view/quiz/quiz_main.dart';
import 'package:motu/view/terminology/terminology_main.dart';
import '../../widget/chatbot_fab.dart';
import '../article/article_list_screen.dart';
import '../news/news_list_screen.dart';
import '../theme/color_theme.dart';

class LearningContentscreen extends StatelessWidget {
  const LearningContentscreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorTheme.colorNeutral,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                  width: screenWidth,
                  height: screenHeight * 0.25,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    color: ColorTheme.colorSecondary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.06),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Transform.translate(
                            offset: const Offset(20, 0),
                            child: const Text(
                              '오늘의 공부\n함께 시작해볼까요?',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.only(
                      top: 50, bottom: 20, right: 20, left: 20),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 20,
                  childAspectRatio: 3 / 4,
                  children: [
                    buildCard(
                        context,
                        '용어\n공부하기',
                        ColorTheme.colorWhite,
                        const TermMain(),
                        'assets/images/character/curious_panda.png',
                        imageHeight: 76),
                    buildCard(
                        context,
                        '퀴즈 풀며\n내 실력\n확인해보기',
                        ColorTheme.colorWhite,
                        QuizSelectionScreen(uid: auth.currentUser!.uid),
                        'assets/images/character/study_panda.png',
                        imageHeight: 76),
                    buildCard(
                        context,
                        '꼭 필요한\n경제꿀팁 읽으며\n경제지식 쌓기',
                        ColorTheme.colorWhite,
                        ArticleListScreen(),
                        'assets/images/character/news_panda.png',
                        imageHeight: 76),
                    buildCard(
                        context,
                        '오늘의\n시사 정보\n확인하기',
                        ColorTheme.colorWhite,
                        const NewsListScreen(),
                        'assets/images/character/teaching_panda.png',
                        imageHeight: 76),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.2,
            left: (screenWidth - screenWidth * 0.8) / 2,
            child: Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.09,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: ColorTheme.colorPrimary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  Transform.translate(
                    offset: Offset(-15, 0),
                    child: Container(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/character/face_circle.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(-15, 0),
                      child: const Text(
                        '즐겁게 공부하고,\n모의투자 머니도 벌어봐요!',
                        style: TextStyle(
                          color: ColorTheme.colorWhite,
                          fontSize: 16,
                          height: 1.3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ChatbotFloatingActionButton(),
    );
  }
}

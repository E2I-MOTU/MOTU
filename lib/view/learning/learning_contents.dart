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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: screenWidth,
              height: screenHeight * 0.3,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: ColorTheme.colorPrimary40,
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
                            fontSize: 22,
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
              ),
            ),

            // Course Section with Button
            Container(
              width: screenWidth,
              height: screenHeight * 0.24,
              padding: const EdgeInsets.only(top: 20, bottom: 10, right: 20, left: 20),
              child: Card(
                color: ColorTheme.colorPrimary,
                elevation: 3,
                child: Stack(
                  children: [
                    // Course Text
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: const Text(
                        '코스별 학습',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TermMain()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          '코스 보기',
                          style: TextStyle(
                            color: ColorTheme.colorPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grid Section
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
              childAspectRatio: 3 / 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 10, bottom: 20, right: 20, left: 20),
              children: [
                buildCard(
                  context,
                  '용어\n공부하기',
                  ColorTheme.colorWhite,
                  const TermMain(),
                  'assets/images/character/curious_panda.png',
                  imageHeight: 76,
                ),
                buildCard(
                  context,
                  '퀴즈 풀며\n내 실력\n확인해보기',
                  ColorTheme.colorWhite,
                  QuizSelectionScreen(uid: auth.currentUser!.uid),
                  'assets/images/character/study_panda.png',
                  imageHeight: 76,
                ),
                buildCard(
                  context,
                  '꼭 필요한\n경제꿀팁 읽으며\n경제지식 쌓기',
                  ColorTheme.colorWhite,
                  ArticleListScreen(),
                  'assets/images/character/news_panda.png',
                  imageHeight: 76,
                ),
                buildCard(
                  context,
                  '오늘의\n시사 정보\n확인하기',
                  ColorTheme.colorWhite,
                  const NewsListScreen(),
                  'assets/images/character/teaching_panda.png',
                  imageHeight: 76,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: ChatbotFloatingActionButton(),
    );
  }
}

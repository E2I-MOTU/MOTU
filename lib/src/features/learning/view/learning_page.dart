import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motu/src/features/learning/course/view/course_list_page.dart';
import 'package:motu/src/features/learning/news/view/news_list_screen.dart';
import 'package:motu/src/features/learning/term/view/term_main_page.dart';
import 'package:motu/src/features/learning/view/widget/learning_card_builder.dart';
import 'package:motu/src/features/learning/quiz/view/quiz_main.dart';
import '../../../common/view/widget/chatbot_fab.dart';
import '../column/view/article_list_screen.dart';

import '../../../design/color_theme.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

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
                    padding: EdgeInsets.only(top: screenHeight * 0.15),
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

            // // Course Section with Button
            // Container(
            //   width: screenWidth,
            //   height: screenHeight * 0.24,
            //   padding: const EdgeInsets.only(
            //       top: 20, bottom: 10, right: 20, left: 20),
            //   child: Card(
            //     color: ColorTheme.colorPrimary,
            //     elevation: 3,
            //     child: Stack(
            //       children: [
            //         // Course Text
            //         const Padding(
            //           padding: EdgeInsets.all(20),
            //           child: Text(
            //             '코스별 학습',
            //             style: TextStyle(
            //               fontSize: 16,
            //               color: Colors.white,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),

            //         // Button to navigate to CourseListScreen
            //         Positioned(
            //           bottom: 10,
            //           right: 10,
            //           child: ElevatedButton(
            //             onPressed: () {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => const CourseListPage()),
            //               );
            //             },
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: Colors.white,
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 20, vertical: 10),
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(20),
            //               ),
            //             ),
            //             child: const Text(
            //               '코스 보기',
            //               style: TextStyle(
            //                 color: ColorTheme.colorPrimary,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // Grid Section
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
              childAspectRatio: 3 / 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                  top: 10, bottom: 20, right: 20, left: 20),
              children: [
                LearingCardBuilder(
                  context,
                  '용어\n공부하기',
                  ColorTheme.colorWhite,
                  const TermMainPage(),
                  'assets/images/character/curious_panda.png',
                  imageHeight: 76,
                ),
                LearingCardBuilder(
                  context,
                  '퀴즈 풀며\n내 실력\n확인해보기',
                  ColorTheme.colorWhite,
                  QuizSelectionScreen(uid: auth.currentUser!.uid),
                  'assets/images/character/study_panda.png',
                  imageHeight: 76,
                ),
                LearingCardBuilder(
                  context,
                  '꼭 필요한\n경제꿀팁 읽으며\n경제지식 쌓기',
                  ColorTheme.colorWhite,
                  ArticleListScreen(),
                  'assets/images/character/news_panda.png',
                  imageHeight: 76,
                ),
                LearingCardBuilder(
                  context,
                  '오늘의\n시사 정보\n확인하기',
                  ColorTheme.colorWhite,
                  const NewsListPage(),
                  'assets/images/character/teaching_panda.png',
                  imageHeight: 76,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: const ChatbotFloatingActionButton(
        heroTag: 'learning',
      ),
    );
  }
}

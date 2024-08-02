import 'package:flutter/material.dart';

import '../../theme/color_theme.dart';
import '../terminology_quiz.dart';

Widget buildCompletionPage(BuildContext context, String title, String documentName, String uid) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '학습 완료!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          '축하합니다! 모든 카드를 학습하셨습니다. \n 테스트를 통과하고 수료까지 해보세요!',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%로 설정
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermQuizScreen(
                    collectionName: 'terminology',
                    documentName: documentName,
                    uid: uid,
                  ),
                ),
              );
            },
            child: Text(
              '테스트 응시하기',
              style: TextStyle(fontSize: 16,),
            ),
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent, // 그림자 제거
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: ColorTheme.colorPrimary,
              foregroundColor: ColorTheme.colorWhite,
            ),
          ),
        ),
      ],
    ),
  );
}
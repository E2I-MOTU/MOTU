import 'package:flutter/material.dart';

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
          '축하합니다! 모든 카드를 학습하셨습니다.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        ElevatedButton(
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
          child: Text('퀴즈 풀기'),
        ),
      ],
    ),
  );
}
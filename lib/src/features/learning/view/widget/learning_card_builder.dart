import 'package:flutter/material.dart';
import '../../../../design/color_theme.dart';

Widget LearingCardBuilder(BuildContext context, String text, Color color,
    Widget? nextScreen, String imagePath,
    {double? imageHeight}) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return Container(
    width: screenWidth * 0.4, // 카드 크기를 화면 너비의 비율로 설정
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 2,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown, // 텍스트 크기 자동 조정
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
          ),
        ),
        Flexible(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.asset(
              imagePath,
              height: imageHeight ?? screenHeight * 0.1, // 이미지 크기를 화면 높이에 비례
              fit: BoxFit.contain,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: ElevatedButton(
            onPressed: () {
              if (nextScreen != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nextScreen),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: ColorTheme.colorSecondary,
              foregroundColor: ColorTheme.colorWhite,
              minimumSize: const Size(120, 36),
            ),
            child: const Text('도전하기'),
          ),
        ),
      ],
    ),
  );
}

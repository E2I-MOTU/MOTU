import 'package:flutter/material.dart';
import '../../theme/color_theme.dart';

Widget buildCard(
    BuildContext context,
    String text,
    Color color,
    Widget? nextScreen,
    String imagePath,
    {double? imageHeight}) {

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
          offset: const Offset(0, 4), // 그림자의 위치 (x, y)
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 8),
          child: Align(
            alignment: Alignment.topLeft,
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
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Image.asset(
            imagePath,
            height: imageHeight,
            fit: BoxFit.contain,
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
            minimumSize: const Size(140, 40),
          ),
        ),
      ],
    ),
  );
}

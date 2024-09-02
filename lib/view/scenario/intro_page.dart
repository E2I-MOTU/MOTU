import 'package:flutter/material.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/view/scenario/widget/tutorial_popup.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;

import 'scenario_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScenarioService>(context);

    provider.showTutorialPopup = (ScenarioType type) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: TutorialPopup(type: type),
          );
        },
      );
    };

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/scenario/scenario_bg.png", // 배경 이미지 경로
            fit: BoxFit.cover, // 화면 전체에 맞게 이미지 크기 조정
            width: double.infinity, // 가로를 화면 전체로
            height: double.infinity, // 세로를 화면 전체로
          ),
          Positioned(
            left: 32,
            right: 32,
            bottom: 48, // 버튼과 화면 하단 사이의 간격
            child: SizedBox(
              height: 55,
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScenarioPage()),
                    (route) => false,
                  );

                  Provider.of<ScenarioService>(context, listen: false)
                      .initializeData();
                },
                style: TextButton.styleFrom(
                  backgroundColor: ColorTheme.Purple1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "시나리오 시작하기",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: ColorTheme.White,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

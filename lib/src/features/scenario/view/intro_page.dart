import 'package:flutter/material.dart';
import 'package:motu/src/features/scenario/service/scenario_service.dart';
import 'package:motu/src/features/scenario/view/widget/tutorial_popup.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:motu/src/common/view/widget/chatbot_fab.dart';
import 'dart:developer' as dev;

class IntroPage extends StatelessWidget {
  final ScenarioService service;
  const IntroPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    void showTutorialPopup(ScenarioType type) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: TutorialPopup(type: type),
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 48),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: ScenarioType.values.length,
                  itemBuilder: (context, index) {
                    final scenario = ScenarioType.values[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: ListTile(
                        title: Text(service.getScenarioTitle(scenario)),
                        tileColor: ColorTheme.Grey1,
                        minVerticalPadding: 30,
                        contentPadding: const EdgeInsets.only(left: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onTap: () {
                          dev.log(
                              "📈 ${service.getScenarioTitle(scenario)} 시나리오 시작");

                          showTutorialPopup(scenario);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          const ChatbotFloatingActionButton(heroTag: 'scenario'),
    );

    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       Image.asset(
    //         "assets/images/scenario/scenario_bg.png", // 배경 이미지 경로
    //         fit: BoxFit.cover, // 화면 전체에 맞게 이미지 크기 조정
    //         width: double.infinity, // 가로를 화면 전체로
    //         height: double.infinity, // 세로를 화면 전체로
    //       ),
    //       Positioned(
    //         left: 32,
    //         right: 32,
    //         bottom: 48, // 버튼과 화면 하단 사이의 간격
    //         child: SizedBox(
    //           height: 55,
    //           child: TextButton(
    //             onPressed: () {
    //               dev.log("📈 Start scenario");

    //               final auth = Provider.of<AuthService>(context, listen: false);
    //               final scenario =
    //                   Provider.of<ScenarioService>(context, listen: false);

    //               scenario.setOriginBalance(auth.user!.balance);

    //               scenario.resetAllData();

    //               final random = Random();
    //               // ScenarioType의 길이를 구하고 그 중에서 랜덤 인덱스를 생성
    //               final randomIndex =
    //                   random.nextInt(ScenarioType.values.length);
    //               ScenarioType type = ScenarioType.values[randomIndex];
    //               scenario.setSelectedScenario(type);
    //               dev.log("Selected Scenario: $type");

    //               Navigator.pushAndRemoveUntil(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (context) => const ScenarioPage()),
    //                 (route) => false,
    //               );

    //               Provider.of<ScenarioService>(context, listen: false)
    //                   .initializeData();
    //             },
    //             style: TextButton.styleFrom(
    //               backgroundColor: ColorTheme.Purple1,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //             ),
    //             child: const Text(
    //               "시나리오 시작하기",
    //               style: TextStyle(
    //                 fontSize: 17,
    //                 fontWeight: FontWeight.bold,
    //                 color: ColorTheme.White,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   floatingActionButton: ChatbotFloatingActionButton(),
    // );
  }
}

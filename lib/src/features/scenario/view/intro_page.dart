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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(
              color: ColorTheme.Purple5,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(24, 56, 24, 24),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "실전학습을 통해 \n주식투자에 대한 감을 익혀볼까요?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorTheme.White,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ScenarioType.values.length,
              itemBuilder: (context, index) {
                final scenario = ScenarioType.values[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: ListTile(
                    title: Text(service.getScenarioTitle(scenario),
                        style: const TextStyle(
                            color: ColorTheme.White,
                            fontWeight: FontWeight.bold)),
                    tileColor: ColorTheme.Purple2,
                    minVerticalPadding: 30,
                    contentPadding: const EdgeInsets.only(left: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: () {
                      dev.log(
                          "📈 ${service.getScenarioTitle(scenario)} 시나리오 시작");
                      service.setSelectedScenario(scenario);

                      showTutorialPopup(scenario);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton:
          const ChatbotFloatingActionButton(heroTag: 'scenario'),
    );
  }
}

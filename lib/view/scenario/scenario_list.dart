import 'package:flutter/material.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/widget/motu_button.dart';
import 'package:provider/provider.dart';

import 'scenario_page.dart';

class ScenarioList extends StatelessWidget {
  const ScenarioList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 여기에 다른 위젯들을 추가할 수 있습니다.
          Positioned(
            left: 32,
            right: 32,
            bottom: 48, // 버튼과 화면 하단 사이의 간격
            child: SizedBox(
              height: 55,
              child: MotuNormalButton(
                context,
                onPressed: () {
                  final scenarioService = context
                      .read<ScenarioService>(); // ScenarioService 인스턴스 생성
                  scenarioService.setSelectedScenario(ScenarioType.covid);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScenarioPage()),
                  );
                },
                color: Theme.of(context).primaryColor,
                text: "시나리오 시작하기",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

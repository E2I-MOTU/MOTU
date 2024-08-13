import 'package:flutter/material.dart';
import 'package:motu/provider/scenario_service.dart';

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
            left: 20,
            right: 20,
            bottom: 24, // 버튼과 화면 하단 사이의 간격
            child: ElevatedButton(
              onPressed: () {
                ScenarioService();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScenarioPage()),
                );
              },
              child: const Text("시뮬레이션 시작하기"),
            ),
          ),
        ],
      ),
    );
  }
}

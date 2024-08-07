import 'package:flutter/material.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/view/scenario/scenario_page.dart';

class ScenarioList extends StatelessWidget {
  const ScenarioList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("주제", style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: () {
                ScenarioService();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScenarioPage()),
                );
              },
              child: const Text("시작"),
            ),
          ],
        ),
      ),
    );
  }
}

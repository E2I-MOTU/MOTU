import 'package:flutter/material.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/view/scenario/scenario_chart.dart';

class ScenarioList extends StatelessWidget {
  const ScenarioList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scenario List'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScenarioService();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ScenarioChart()));
          },
          child: const Text("TEST"),
        ),
      ),
    );
  }
}

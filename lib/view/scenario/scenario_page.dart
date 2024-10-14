import 'package:flutter/material.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/view/scenario/content_page.dart';
import 'package:motu/view/scenario/intro_page.dart';
import 'package:provider/provider.dart';

class ScenarioPage extends StatelessWidget {
  const ScenarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScenarioService>(
      builder: (context, service, child) {
        return service.checkingScenarioIsRunning()
            ? ContentPage(service: service)
            : IntroPage(service: service);
      },
    );
  }
}

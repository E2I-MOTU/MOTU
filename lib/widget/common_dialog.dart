import 'package:flutter/material.dart';
import 'package:motu/model/balance_detail.dart';
import 'package:motu/service/auth_service.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/widget/motu_button.dart';
import 'package:provider/provider.dart';

import '../provider/navigation_provider.dart';
import '../view/main_page.dart';

Widget CommonDialog(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return AlertDialog(
    backgroundColor: Colors.white,
    content: Stack(
      children: [
        Positioned(
          right: -10,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: MotuNormalButton(
                    context,
                    text: "아니요",
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MotuCancelButton(
                    context: context,
                    text: "예",
                    onPressed: () {
                      final navService = Provider.of<NavigationService>(context,
                          listen: false);
                      navService.setSelectedIndex(2);

                      final scenarioService =
                          Provider.of<ScenarioService>(context, listen: false);
                      scenarioService.resetAllData();

                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      authService.setUserBalance(
                          (scenarioService.originBalance * 0.9).toInt());

                      authService.addBalanceDetail(BalanceDetail(
                        date: DateTime.now(),
                        content: "시나리오 중도 포기 패널티",
                        amount: (scenarioService.originBalance * 0.1).toInt(),
                        isIncome: false,
                      ));

                      Navigator.replace(
                        context,
                        oldRoute: ModalRoute.of(context)!,
                        newRoute: MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.3,
          width: size.width * 0.7,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32),
              Text(
                "정말 나가실 건가요?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              Text(
                "중도 포기하면 수수료로 기존 자산의 10% 금액만큼 차감됩니다.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

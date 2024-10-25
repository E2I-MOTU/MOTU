import 'package:flutter/material.dart';
import 'package:motu/src/common/database.dart';
import 'package:motu/src/features/scenario/service/scenario_service.dart';
import 'package:motu/src/common/view/widget/motu_button.dart';
import 'package:provider/provider.dart';

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
          left: 10,
          right: 10,
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
                      Navigator.of(context).pop();

                      Provider.of<ScenarioService>(context, listen: false)
                          .resetAllData();

                      setScenarioIsRunning(false);
                      Provider.of<ScenarioService>(context, listen: false)
                          .checkingScenarioIsRunning();
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
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "정말 나가실 건가요?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "현재까지 진행했던 시나리오 데이터가 모두 초기화됩니다.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:motu/model/scenario_result.dart';
import 'package:motu/service/auth_service.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/util/util.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';

class CompletedScenarioPage extends StatelessWidget {
  const CompletedScenarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('참여한 시나리오 기록'),
      ),
      body: Consumer<AuthService>(builder: (context, service, child) {
        return Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: service.user.scenarioRecord.length,
                itemBuilder: (context, index) {
                  Size size = MediaQuery.of(context).size;

                  ScenarioResult result = service.user.scenarioRecord[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      child: Stack(
                        children: [
                          Image.asset(
                            "assets/images/scenario/scenario_result_box.png",
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                          Positioned(
                            left: 20,
                            top: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(result.subject,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    "${result.date.year}년 ${result.date.month}월 ${result.date.day}일",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: ColorTheme.Black2)),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 20,
                            bottom: 12,
                            width: size.width * 0.32,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "총 손익",
                                      style: TextStyle(
                                          color: ColorTheme.White,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      result.isIncome
                                          ? "+ ${Formatter.format(result.totalReturn)}"
                                          : "- ${Formatter.format(result.totalReturn)}",
                                      style: const TextStyle(
                                          color: ColorTheme.White,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "수익률",
                                      style: TextStyle(
                                          color: ColorTheme.White,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      result.isIncome
                                          ? "+${result.returnRate}%"
                                          : "-${result.returnRate}%",
                                      style: const TextStyle(
                                          color: ColorTheme.White,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

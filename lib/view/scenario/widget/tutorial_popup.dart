import 'package:flutter/material.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/view/scenario/tutorial_page.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';

class TutorialPopup extends StatelessWidget {
  final ScenarioType type;

  const TutorialPopup({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<ScenarioService>(builder: (context, service, child) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: size.height * 0.03,
        ),
        width: size.width * 0.8,
        height: size.height * 0.6,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width * 0.8,
                      child: TextButton(
                        onPressed: () {
                          service.setIsOnTutorial(true);

                          // 튜토리얼 페이지로 이동
                          Navigator.replace(context,
                              oldRoute: ModalRoute.of(context)!,
                              newRoute: MaterialPageRoute(
                                  builder: (context) => const TutorialPage()));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: ColorTheme.Purple1,
                          backgroundColor: ColorTheme.Purple5,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: const Text("튜토리얼 보러가기"),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: size.width * 0.8,
                      child: TextButton(
                        onPressed: () {
                          // service.setIsStartScenario(true);
                          // // 주식 차트 타이머 시작
                          // service.startDataUpdate();
                          // // 남은 시간 타이머 시작
                          // service.startRemainingTimeTimer();

                          // 튜토리얼 팝업 닫기
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: ColorTheme.White,
                          backgroundColor: ColorTheme.Purple1,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: const Text(
                          "바로 시작",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                _buildTitle(service.selectedScenario!),
                const SizedBox(height: 24),
                _buildContent(service.selectedScenario!),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTitle(ScenarioType type) {
    switch (type) {
      case ScenarioType.covid:
        return const Text(
          "COVID-19",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        );
      case ScenarioType.secondaryBattery:
        return const Text(
          "2차 전지",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        );
    }
  }

  Widget _buildContent(ScenarioType type) {
    switch (type) {
      case ScenarioType.covid:
        return const Column(
          children: [
            Text(
              "코로나 19 사태 당시의 시대 흐름을 알려드려요.",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(height: 16),
            Text(
                "👉 팬데믹 사태로 인한 사회적 거리두기 → 각국 정부의 코로나 확산 방지를 위해 출입국 금지 → 여행 불가 → 항공사, 여행사 타격 → 온라인 서비스 수요 증가 → 배달, 온라인 쇼핑 주가 상승",
                style: TextStyle(fontSize: 13)),
            SizedBox(height: 5),
            Text("👉 사회적 거리두기로 인한 원격 근무, 원격 교육 수요 급증",
                style: TextStyle(fontSize: 13)),
            SizedBox(height: 5),
            Text("👉 바이러스 백신 수요로 인한 제약회사 주가 상승",
                style: TextStyle(fontSize: 13)),
          ],
        );
      case ScenarioType.secondaryBattery:
        return const SizedBox();
    }
  }
}

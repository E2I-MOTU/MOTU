import 'package:flutter/material.dart';
import 'package:motu/src/common/database.dart';
import 'package:motu/src/features/login/service/auth_service.dart';
import 'package:motu/src/features/scenario/service/scenario_service.dart';
import 'package:motu/src/features/scenario/view/tutorial_page.dart';
import 'package:motu/src/design/color_theme.dart';
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
          horizontal: size.width * 0.03,
          vertical: size.height * 0.01,
        ),
        width: size.width * 0.9,
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
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.01,
                          ),
                        ),
                        child: const Text("튜토리얼 보러가기"),
                      ),
                    ),
                    const SizedBox(height: 1),
                    SizedBox(
                      width: size.width * 0.9,
                      child: TextButton(
                        onPressed: () {
                          // 튜토리얼 팝업 닫기
                          Navigator.pop(context);

                          // 시나리오 기존데이터 초기화
                          service.resetAllData();

                          // 유저 기존 자금 저장
                          service.setOriginBalance(
                              Provider.of<AuthService>(context, listen: false)
                                      .user
                                      ?.balance ??
                                  0);

                          // 시나리오 지정
                          service.setSelectedScenario(type);

                          // 시나리오 초기 설정 시작
                          service.initializeData();

                          // 시나리오 진행중으로 설정
                          setScenarioIsRunning(true);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: ColorTheme.White,
                          backgroundColor: ColorTheme.Purple1,
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.01,
                          ),
                        ),
                        child: const Text(
                          "시작하기",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  _buildTitle(service.selectedScenario ?? type),
                  const SizedBox(height: 24),
                  _buildContent(service.selectedScenario ?? type),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTitle(ScenarioType type) {
    switch (type) {
      case ScenarioType.disease:
        return const Text(
          "COVID-19",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        );
      case ScenarioType.secondaryBattery:
        return const Text(
          "2차 전지",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildContent(ScenarioType type) {
    switch (type) {
      case ScenarioType.disease:
        return const Column(
          children: [
            Text(
              "코로나 19 사태 당시의 시대 흐름을 알려드려요.",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(height: 12),
            Text(
                "👉 팬데믹 사태로 인한 사회적 거리두기 → 각국 정부의 코로나 확산 방지를 위해 출입국 금지 → 여행 불가 → 항공사, 여행사 타격 → 온라인 서비스 수요 증가 → 배달, 온라인 쇼핑 주가 상승",
                style: TextStyle(fontSize: 12)),
            SizedBox(height: 5),
            Text("👉 사회적 거리두기로 인한 원격 근무, 원격 교육 수요 급증",
                style: TextStyle(fontSize: 12)),
            SizedBox(height: 5),
            Text("👉 바이러스 백신 수요로 인한 제약회사 주가 상승",
                style: TextStyle(fontSize: 12)),
          ],
        );
      case ScenarioType.secondaryBattery:
        return const Column(
          children: [
            Text(
              "2차 전지 시장의 시대 흐름을 알려드려요.",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "👉 전기차 수요 증가 → 각국 정부의 친환경 정책 강화 → 2차 전지 제조업체의 성장 기대감 상승",
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 5),
            Text(
              "👉 재생 가능 에너지 확산 → 배터리 저장 시스템 필요성 증가 → 2차 전지 산업의 확장",
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 5),
            Text(
              "👉 기술 혁신과 생산 비용 절감으로 인한 경쟁력 강화",
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}

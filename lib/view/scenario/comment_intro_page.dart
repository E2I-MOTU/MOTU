import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motu/service/navigation_service.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/view/nav_page.dart';
import 'package:motu/view/news/news_list_screen.dart';
import 'package:motu/view/terminology/terminology_main.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';

class CommentIntroPage extends StatelessWidget {
  const CommentIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('시나리오 해설'),
      ),
      body: SingleChildScrollView(
        child: Consumer<ScenarioService>(builder: (context, service, child) {
          return Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/scenario/comment_char.png',
                  fit: BoxFit.contain,
                  width: size.width * 0.6,
                ),
                const SizedBox(height: 24),
                _buildHeaderText(
                    service.selectedScenario ?? ScenarioType.disease),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: ColorTheme.White,
                    backgroundColor: ColorTheme.Purple1,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline),
                      SizedBox(width: 8),
                      Text('자세히 공부하기'),
                    ],
                  ),
                ),
                const SizedBox(height: 42),
                _buildRecommendContent(
                    context, service.selectedScenario ?? ScenarioType.disease),
                const SizedBox(height: 42),
                TextButton(
                  onPressed: () {
                    Provider.of<NavigationService>(context, listen: false)
                        .setSelectedIndex(0);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavPage(),
                      ),
                      (route) => false, // 모든 기존 경로를 제거
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: ColorTheme.Purple1,
                    backgroundColor: ColorTheme.White,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home_filled),
                      SizedBox(width: 8),
                      Text('메인 홈으로 돌아가기'),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.1),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeaderText(ScenarioType type) {
    switch (type) {
      case ScenarioType.disease:
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.0),
          child: Column(
            children: [
              Text(
                "코로나19가 주가에 어떤 영향을 주었는지 알려드려요.",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              Text(
                "코로나19 바이러스는 경제에 큰 타격을 주어 소비와 생산이 감소하고 실업률이 급증했습니다. 주식 시장에서는 초기 급락 이후 백신 개발과 경제 재개 기대감으로 회복세를 보였지만, 여전히 높은 변동성을 유지하고 있습니다.\n\n이에 따른 주식 시장의 변동을 살펴볼까요?",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      case ScenarioType.secondaryBattery:
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.0),
          child: Column(
            children: [
              Text(
                "2차 전지가 주가에 어떤 영향을 주었는지 알려드려요.",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              Text(
                "2차 전지는 전기차 시대를 이끌어가는 핵심 부품으로, 전기차의 보급 확대에 따라 수요가 급증하고 있습니다. 이에 따라 2차 전지 관련 기업들의 주가는 상승세를 보이고 있습니다. \n\n이에 따른 주식 시장의 변동을 살펴볼까요?",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildRecommendContent(BuildContext context, ScenarioType type) {
    switch (type) {
      case ScenarioType.disease:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Column(
              children: [
                const Text(
                  "MOTU 추천 컨텐츠",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.newspaper_outlined),
                  title: const Text(
                    "COVID-19 테마주 관련 기사",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "관련 산업 보고서로 공부해보세요!",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  dense: true,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: ColorTheme.Grey2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewsListScreen()));
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(CupertinoIcons.question),
                  title: const Text(
                    "재무제표 용어 퀴즈",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "재무제표를 퀴즈 풀며 공부해요!",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  dense: true,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: ColorTheme.Grey2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermMain()));
                  },
                ),
              ],
            ),
          ),
        );
      case ScenarioType.secondaryBattery:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Column(
              children: [
                const Text(
                  "MOTU 추천 컨텐츠",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.newspaper_outlined),
                  title: const Text(
                    "2차 전지 테마주 관련 기사",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "관련 산업 보고서로 공부해보세요!",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  dense: true,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: ColorTheme.Grey2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewsListScreen()));
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(CupertinoIcons.question),
                  title: const Text(
                    "재무제표 용어 퀴즈",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "재무제표를 퀴즈 풀며 공부해요!",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  dense: true,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: ColorTheme.Grey2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermMain()));
                  },
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motu/src/common/service/navigation_service.dart';
import 'package:motu/src/features/scenario/service/scenario_service.dart';
import 'package:motu/src/common/view/nav_page.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:motu/src/features/learning/news/view/news_list_screen.dart';
import 'package:motu/src/features/learning/term/view/term_main_page.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

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
                _buildHeaderText(service.selectedScenario),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    toastification.show(
                      type: ToastificationType.info,
                      title: const Text("알림",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red)),
                      description: const Text("준비 중입니다!\n곧 있을 업데이트를 기대해주세요 :)",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      autoCloseDuration: const Duration(seconds: 2),
                      alignment: Alignment.center,
                      showProgressBar: false,
                      animationDuration: const Duration(milliseconds: 500),
                      animationBuilder: (context, animation, alignment, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    );
                  },
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
                _buildRecommendContent(context, service.selectedScenario),
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
      case ScenarioType.festival:
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.0),
          child: Column(
            children: [
              Text(
                "MOTU는 재밌고 효과적으로 쉽게 배울 수 있는 금융 교육을 제공해요.",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              Text(
                "MOTU는 단순히 주식 투자에 그치지 않고, 올바른 금융 가치관을 형성하며 지속 가능한 경제 생활을 할 수 있도록 도와줘요. \n\n우리 다함께 MOTU 할까요?",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
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
                            builder: (context) => const NewsListPage()));
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
                            builder: (context) => const TermMainPage()));
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
                            builder: (context) => const NewsListPage()));
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
                            builder: (context) => const TermMainPage()));
                  },
                ),
              ],
            ),
          ),
        );
      case ScenarioType.festival:
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
                    "여러 테마주 관련 기사",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "최신 산업 보고서로 공부해보세요!",
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
                            builder: (context) => const NewsListPage()));
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
                            builder: (context) => const TermMainPage()));
                  },
                ),
              ],
            ),
          ),
        );
    }
  }
}

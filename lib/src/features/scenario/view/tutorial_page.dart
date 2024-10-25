import 'package:flutter/material.dart';
import 'package:motu/src/common/database.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:motu/src/features/login/service/auth_service.dart';
import 'package:motu/src/features/scenario/service/scenario_service.dart';
import 'package:provider/provider.dart';

class TutorialPage extends StatefulWidget {
  final ScenarioType type;

  const TutorialPage({super.key, required this.type});

  @override
  TutorialPageState createState() => TutorialPageState();
}

class TutorialPageState extends State<TutorialPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Image> _pages = [
    Image.asset('assets/images/scenario/tutorial/1.png', fit: BoxFit.fill),
    Image.asset('assets/images/scenario/tutorial/2.png', fit: BoxFit.fill),
    Image.asset('assets/images/scenario/tutorial/3.png', fit: BoxFit.fill),
    Image.asset('assets/images/scenario/tutorial/4.png', fit: BoxFit.fill),
    Image.asset('assets/images/scenario/tutorial/5.png', fit: BoxFit.fill),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4D4D4D),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return _pages[index];
                  },
                ),
              ),
            ],
          ),
          _currentPage == _pages.length - 1
              ? Positioned(
                  bottom: 40.0,
                  left: 12,
                  right: 12,
                  child: ElevatedButton(
                    onPressed: () {
                      // 튜토리얼 팝업 닫기
                      Navigator.pop(context);

                      // 시나리오 서비스 가져오기
                      final service =
                          Provider.of<ScenarioService>(context, listen: false);

                      // 시나리오 기존데이터 초기화
                      service.resetAllData();

                      // 유저 기존 자금 저장
                      service.setOriginBalance(
                          Provider.of<AuthService>(context, listen: false)
                                  .user
                                  ?.balance ??
                              0);

                      // 시나리오 지정
                      service.setSelectedScenario(widget.type);

                      // 시나리오 초기 설정 시작
                      service.initializeData();

                      // 시나리오 진행중으로 설정
                      setScenarioIsRunning(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorTheme.Purple1,
                      foregroundColor: ColorTheme.White,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                    ),
                    child: const FittedBox(
                      child: Text(
                        '시작하기',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          Positioned(
            top: 6.0,
            left: 12,
            right: 12,
            child: SafeArea(
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / _pages.length,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(ColorTheme.Purple2),
                backgroundColor: ColorTheme.Grey2,
                minHeight: 8,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:motu/main.dart';
import 'package:motu/src/common/database.dart';
import 'package:motu/src/common/view/nav_page.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:motu/src/features/login/service/auth_service.dart';
import 'package:motu/src/features/login/view/login.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatelessWidget {
  final RichText description;
  final String image;

  const OnboardingPage(
      {super.key, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
            child: description,
          ),
        ],
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      description: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(fontSize: 16.0, color: Colors.black), // 기본 텍스트 스타일
          children: <TextSpan>[
            TextSpan(
              text:
                  '시장 동향과 뉴스에 민감하게 반응하는 것은 매우 중요합니다! \n\n주식 시장의 변동성과 불확실성에 대응하며 ',
            ),
            TextSpan(
              text: '안전하게 투자연습 ',
              style: TextStyle(color: ColorTheme.Purple1), // 색상을 입힌 텍스트 스타일
            ),
            TextSpan(
              text: '해보세요',
            ),
          ],
        ),
      ),
      image: 'assets/images/login/onboarding/onboarding1.png',
    ),
    OnboardingPage(
      description: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(fontSize: 16.0, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: '주식투자는 ',
            ),
            TextSpan(
              text: '지속적인 학습',
              style: TextStyle(color: ColorTheme.Purple1),
            ),
            TextSpan(
              text: '과 탐구가 필요한 분야입니다. 잘 몰랐던 경제 상식, 주식 용어를 쉽게 익혀보아요.\n\n',
            ),
            TextSpan(
              text: '학습을 클리어할 때마다 모의투자 자금을 얻을 수 있어요! ',
            ),
            TextSpan(
              text: '꾸준한 공부',
              style: TextStyle(color: ColorTheme.Purple1),
            ),
            TextSpan(
              text: '로 더 많은 자금을 모아서 투자 연습 해보세요.',
            ),
          ],
        ),
      ),
      image: 'assets/images/login/onboarding/onboarding2.png',
    ),
    OnboardingPage(
      description: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(fontSize: 16.0, color: Colors.black), // 기본 텍스트 스타일
          children: <TextSpan>[
            TextSpan(
              text: 'MOTU는 단순히 주식 투자에 그치지 않고, ',
            ),
            TextSpan(
              text: '올바른 금융 가치관',
              style: TextStyle(color: ColorTheme.Purple1),
            ),
            TextSpan(
              text: '을 형성하며 ',
            ),
            TextSpan(
              text: '지속 가능한 경제 생활',
              style: TextStyle(color: ColorTheme.Purple1),
            ),
            TextSpan(
              text: '을 할 수 있도록 도와줘요.\n\n',
            ),
            TextSpan(
              text: '이론과 실전을 결합한 투자 학습으로 ',
            ),
            TextSpan(
              text: '안전하고 책임감 있는 투자 결정',
              style: TextStyle(color: ColorTheme.Purple1),
            ),
            TextSpan(
              text: '을 내릴 수 있게 될 거에요!',
            ),
          ],
        ),
      ),
      image: 'assets/images/login/onboarding/onboarding3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => buildDot(index: index),
            ),
          ),
          const SizedBox(height: 32.0),
          _currentPage == _pages.length - 1
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // setOnboardingDone();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );

                      // if (authService.auth.currentUser == null) {
                      //   Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const LoginPage(),
                      //     ),
                      //   );
                      // } else {
                      //   authService.getUserInfo().then((value) {
                      //     log('🔓 사용자 정보 로드 완료');
                      //   });
                      //   Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const NavPage(),
                      //     ),
                      //   );
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorTheme.Purple1,
                      foregroundColor: ColorTheme.White,
                      padding:
                          const EdgeInsets.fromLTRB(40.0, 14.0, 40.0, 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      '모투하러 가기',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Opacity(
                  opacity: 0.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorTheme.Purple1,
                        foregroundColor: ColorTheme.White,
                        padding:
                            const EdgeInsets.fromLTRB(40.0, 14.0, 40.0, 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        '모투하러 가기',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }

  Widget buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? ColorTheme.Purple1 : Colors.grey,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}

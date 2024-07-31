import 'dart:async';
import 'package:flutter/material.dart';
import '../../widget/drawer_menu.dart';
import '../../service/home_service.dart';
import '../theme/color_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentSlide = 0;
  late PageController _pageController;
  late Timer _timer;
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        currentSlide = (currentSlide + 1) % 4;
      });
      _pageController.animateToPage(
        currentSlide,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.colorWhite,
      appBar: AppBar(
        backgroundColor: ColorTheme.colorWhite,
        title: const Text('홈페이지'),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (value) {
                          setState(() {
                            currentSlide = value;
                          });
                        },
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: ColorTheme.colorDisabled,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              4,
                                  (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: currentSlide == index ? 15 : 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: currentSlide == index
                                      ? ColorTheme.colorPrimary
                                      : ColorTheme.colorWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "오늘의 추천 학습",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("전체보기"),
                      style: TextButton.styleFrom(
                        foregroundColor: ColorTheme.colorFont, // 버튼 텍스트 색상 설정
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(4, (index) {
                      return AspectRatio(
                        aspectRatio: 2.6 / 3,
                        child: Container(
                          margin: const EdgeInsets.only(right: 15.0),
                          decoration: BoxDecoration(
                            color: ColorTheme.colorDisabled,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 30,),
                GestureDetector(
                  onTap: () => _controller.checkAttendance(context),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorTheme.colorDisabled,
                    ),
                    child: Center(
                      child: Text(
                        '출석체크',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorTheme.colorWhite,),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

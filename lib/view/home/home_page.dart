import 'package:flutter/material.dart';
import '../../service/home_service.dart';
import '../theme/color_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeService _controller = HomeService();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorTheme.colorWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            expandedHeight: screenHeight * 0.3,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    width: screenWidth,
                    decoration: const BoxDecoration(
                      color: ColorTheme.colorDisabled,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 30,
                    child: SizedBox(
                      width: 140,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => _controller.checkAttendance(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorTheme.colorPrimary,
                          foregroundColor: ColorTheme.colorWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('출석체크 하기'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/motu_logo.png',
                height: 100,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        style: TextButton.styleFrom(
                          foregroundColor: ColorTheme.colorFont,
                        ),
                        child: const Text("전체보기"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: screenHeight * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "추천 학습이 표시될 영역입니다.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "학습 진도율",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: screenHeight * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: _buildProgressContainer("지금까지 공부한 용어")),
                        Expanded(child: _buildProgressContainer("지금까지 풀어본 문제")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressContainer(String text) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(
            text == "지금까지 공부한 용어"
                ? 'assets/images/character/curious_panda.png'
                : 'assets/images/character/study_panda.png',
            height: 60,
          ),
          const SizedBox(height: 10),
          Container(
            height: 30,
            width: 80,
            decoration: BoxDecoration(
              color: ColorTheme.colorPrimary40,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [],
            ),
            child: const Center(
              child: Text(
                "00개",
                style: TextStyle(
                  fontSize: 12,
                  color: ColorTheme.colorWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

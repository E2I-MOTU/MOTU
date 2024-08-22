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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        style: TextButton.styleFrom(
                          foregroundColor: ColorTheme.colorFont,
                        ),
                        child: const Text("전체보기"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // 와이어프레임 배경색
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

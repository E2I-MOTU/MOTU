import 'package:flutter/material.dart';
import '../../../../design/color_theme.dart';
import 'course_map_screen.dart';

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('코스 목록'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildCourseCard(context, '기초 경제 코스', '경제의 기본 개념을 배워보세요.'),
                  buildCourseCard(
                      context, '주식 투자의 기초', '주식 투자의 기본을 배우고 시작해보세요.'),
                  buildCourseCard(context, '기초 금융 코스', '금융의 기본을 배우고 지식을 쌓으세요.'),
                  // Add more courses here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCourseCard(
      BuildContext context, String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorTheme.colorPrimary,
          ),
        ),
        subtitle: Text(description),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 2,
          ),
          onPressed: () {
            navigateToCourseMap(context, title, description); // 설명 전달
          },
          child: const Text(
            '시작하기',
            style: TextStyle(color: ColorTheme.colorPrimary),
          ),
        ),
        onTap: () {
          navigateToCourseMap(context, title, description); // 설명 전달
        },
      ),
    );
  }

  void navigateToCourseMap(
      BuildContext context, String courseTitle, String description) {
    List<String> stages = [];

    if (courseTitle == '기초 경제 코스') {
      stages = ['기초 개념', '경제 원리', '시장 구조', '거시 경제', '경제 실습'];
    } else if (courseTitle == '주식 투자의 기초') {
      stages = ['주식의 이해', '투자 전략', '포트폴리오 구성', '리스크 관리', '주식 실습'];
    } else if (courseTitle == '기초 금융 코스') {
      stages = ['금융의 이해', '자산 관리', '투자 기본', '금융 리스크', '금융 실습'];
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseMapScreen(
            courseName: courseTitle,
            courseDescription: description,
            stages: stages),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/color_theme.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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
                  buildCourseCard(context, '주식 투자의 기초', '주식 투자의 기본을 배우고 시작해보세요.'),
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

  Widget buildCourseCard(BuildContext context, String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorTheme.colorPrimary,
          ),
        ),
        subtitle: Text(description),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Button background color
            elevation: 2, // Button elevation
          ),
          onPressed: () {
            // Navigate to course details or lessons
          },
          child: Text(
            '시작하기',
            style: TextStyle(color: ColorTheme.colorPrimary),
          ),
        ),
        onTap: () {
          // Navigate to course details or content screen
        },
      ),
    );
  }
}

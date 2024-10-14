import 'package:flutter/material.dart';
import '../../../../design/color_theme.dart';

class CourseMapScreen extends StatelessWidget {
  final String courseName;
  final String courseDescription;
  final List<String> stages;

  const CourseMapScreen({
    super.key,
    required this.courseName,
    required this.courseDescription,
    required this.stages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              courseDescription,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorTheme.colorPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: stages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      buildStageBadge(context, stages[index], index),
                      if (index != stages.length - 1) buildConnectorLine(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 단계 위젯
  Widget buildStageBadge(BuildContext context, String stage, int index) {
    bool isCompleted = index < 2; // 예시: 첫 2단계 완료
    bool isLocked = index > 2; // 예시: 2단계 이후는 잠금 처리

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: isLocked ? Colors.grey : ColorTheme.colorPrimary,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              isCompleted
                  ? Icons.check
                  : isLocked
                      ? Icons.lock
                      : Icons.play_arrow,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: -25,
          child: Text(
            stage,
            style: TextStyle(
              color: isLocked ? Colors.grey : ColorTheme.colorPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildConnectorLine() {
    return Container(
      width: 2,
      height: 50,
      color: Colors.grey,
    );
  }
}

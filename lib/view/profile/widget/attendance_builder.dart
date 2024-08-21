import 'package:flutter/material.dart';
import '../../theme/color_theme.dart';
import '../attendance_calendar_screen.dart';

List<Widget> buildAttendanceWeek(
    BuildContext context, List<DateTime> attendance) {
  List<Widget> weekWidgets = [];

  for (int i = 0; i < 7; i++) {
    weekWidgets.add(
      Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AttendanceScreen()),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorTheme.colorTertiary,
            ),
            child: Center(child: Text("${i + 1}", textAlign: TextAlign.center)),
          ),
        ),
      ),
    );
  }
  return [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekWidgets,
    ),
  ];
}

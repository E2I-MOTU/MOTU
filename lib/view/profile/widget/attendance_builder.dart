import 'package:flutter/material.dart';
import '../../theme/color_theme.dart';
import '../attendance_calendar_screen.dart';

List<Widget> buildAttendanceWeek(BuildContext context, List<DateTime> attendance) {
  List<Widget> weekWidgets = [];
  List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  DateTime startDate = DateTime.now();
  for (int i = 1; i < attendance.length; i++) {
    if (attendance[i].difference(attendance[i - 1]).inDays > 1) {
      startDate = attendance[i];
    }
  }

  for (int i = 0; i < 7; i++) {
    DateTime day = startDate.add(Duration(days: i));
    bool isChecked = attendance.any((date) => date.year == day.year && date.month == day.month && date.day == day.day);

    weekWidgets.add(
      Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AttendanceScreen()),
            );
          },
          child: Column(
            children: [
              Text(weekdays[day.weekday - 1], style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isChecked ? ColorTheme.colorPrimary : ColorTheme.colorDisabled,
                ),
                child: Icon(
                  isChecked ? Icons.check : Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
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

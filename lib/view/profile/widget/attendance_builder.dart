import 'package:flutter/material.dart';
import '../../theme/color_theme.dart';
import '../attendance_calendar_screen.dart';

List<Widget> buildAttendanceWeek(BuildContext context, List<DateTime> attendance) {
  List<Widget> weekWidgets = [];
  List<String> weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  if (attendance.isEmpty) {
    DateTime today = DateTime.now();
    weekWidgets = _buildWeekFromStartDay(context, weekdays, today, []);
  } else {
    attendance.sort();

    DateTime startDay = attendance.first;

    for (int i = 1; i < attendance.length; i++) {
      if (attendance[i].difference(attendance[i - 1]).inDays > 1) {
        startDay = attendance[i];
      }
    }

    weekWidgets = _buildWeekFromStartDay(context, weekdays, startDay, attendance);
  }

  return [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekWidgets,
    ),
  ];
}

List<Widget> _buildWeekFromStartDay(BuildContext context, List<String> weekdays, DateTime startDay, List<DateTime> attendance) {
  List<Widget> weekWidgets = [];

  for (int i = 0; i < 7; i++) {
    DateTime day = startDay.add(Duration(days: i));
    bool isChecked = attendance.any((date) => date.year == day.year && date.month == day.month && date.day == day.day);
    weekWidgets.add(_buildDayWidget(context, weekdays[day.weekday % 7], day, isChecked));
  }

  return weekWidgets;
}

Widget _buildDayWidget(
    BuildContext context, String weekday, DateTime day, bool isChecked) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AttendanceScreen()),
        );
      },
      child: Column(
        children: [
          Text(weekday),
          const SizedBox(height: 4),
          Text('${day.month}/${day.day}',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isChecked
                  ? ColorTheme.colorPrimary
                  : ColorTheme.colorTertiary,
            ),
            child: isChecked
                ? Image.asset(
              'assets/images/stamp.png',
              fit: BoxFit.cover,
            )
                : Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

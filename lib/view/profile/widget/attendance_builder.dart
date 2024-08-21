import 'package:flutter/material.dart';
import '../../theme/color_theme.dart';
import '../attendance_calendar_screen.dart';

List<Widget> buildAttendanceWeek(BuildContext context, List<DateTime> attendance) {
  List<Widget> weekWidgets = [];
  List<String> weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  DateTime now = DateTime.now();
  DateTime startDay;

  if (attendance.isEmpty) {
    startDay = now;
  } else {
    attendance.sort();
    DateTime lastCheckedDate = attendance.last;

    if (now.difference(lastCheckedDate).inDays > 1) {
      startDay = now;
    } else {
      startDay = lastCheckedDate;
    }
  }

  for (int i = 0; i < 7; i++) {
    DateTime day = startDay.add(Duration(days: i));
    bool isChecked = attendance.any((date) => date.year == day.year && date.month == day.month && date.day == day.day);
    weekWidgets.add(_buildDayWidget(context, weekdays[day.weekday % 7], day, isChecked));
  }

  return [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekWidgets,
    ),
  ];
}

Widget _buildDayWidget(BuildContext context, String weekday, DateTime day, bool isChecked) {
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
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isChecked ? ColorTheme.colorPrimary : ColorTheme.colorTertiary,
            ),
            child: Icon(
              isChecked ? Icons.check : Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

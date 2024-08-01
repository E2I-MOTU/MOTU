import 'package:flutter/material.dart';
import '../../theme/color_theme.dart';
import '../attendance_calendar_screen.dart';

List<Widget> buildAttendanceWeek(BuildContext context, List<DateTime> attendance) {
  List<Widget> weekWidgets = [];
  List<String> weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  DateTime now = DateTime.now();
  DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));

  for (int i = 0; i < 7; i++) {
    DateTime day = startOfWeek.add(Duration(days: i));
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
              Text(weekdays[i], style: TextStyle(fontWeight: FontWeight.bold)),
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

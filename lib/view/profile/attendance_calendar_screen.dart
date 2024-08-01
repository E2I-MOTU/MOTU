import 'package:flutter/material.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../service/profile_service.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ProfileService _service = ProfileService();
  late Future<List<DateTime>> _attendanceFuture;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _attendanceFuture = _service.getAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.colorWhite,
      appBar: AppBar(
        backgroundColor: ColorTheme.colorWhite,
        title: const Text('출석체크'),
      ),
      body: FutureBuilder<List<DateTime>>(
        future: _attendanceFuture,
        builder: (BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('출석 현황을 불러오는 중 오류가 발생했습니다.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('출석 기록이 없습니다.'));
          }

          List<DateTime> attendance = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  bool isChecked = attendance.any((date) =>
                  date.year == day.year &&
                      date.month == day.month &&
                      date.day == day.day);

                  if (isChecked) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorTheme.colorPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return null;
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../login/service/auth_service.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Future<List<DateTime>> _attendanceFuture;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _attendanceFuture =
        Provider.of<AuthService>(context, listen: false).getAttendance();
  }

  void _selectDate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _focusedDay,
            minimumYear: 2020,
            maximumYear: 2030,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _focusedDay = newDate;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.colorWhite,
      appBar: AppBar(
        backgroundColor: ColorTheme.colorWhite,
        title: const Text('출석체크'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today,
                color: ColorTheme.colorPrimary),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DateTime>>(
        future: _attendanceFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) {
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
              locale: 'ko_KR',
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  bool isChecked = attendance.any((date) =>
                      date.year == day.year &&
                      date.month == day.month &&
                      date.day == day.day);

                  if (isChecked) {
                    return Container(
                      margin: const EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: ColorTheme.colorPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return null;
                },
                todayBuilder: (context, day, focusedDay) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        width: 5.0,
                        height: 5.0,
                        decoration: const BoxDecoration(
                          color: ColorTheme.colorPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        '${day.day}',
                        style: const TextStyle(
                          color: ColorTheme.colorPrimary,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

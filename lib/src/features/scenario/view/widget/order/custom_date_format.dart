import 'package:intl/intl.dart';

class CustomDateFormat extends DateFormat {
  CustomDateFormat(String super.pattern);

  DateTime? _lastDate;

  @override
  String format(DateTime date) {
    // 첫 호출 시, 이전 날짜를 현재 날짜로 저장
    _lastDate ??= date;

    String formattedDate;

    // 월이 바뀌었는지 확인
    if (_lastDate!.month != date.month) {
      formattedDate = DateFormat('M월').format(date); // 예: 10월
    } else {
      formattedDate = DateFormat('d일').format(date); // 예: 4일, 7일
    }

    // 현재 날짜를 이전 날짜로 업데이트
    _lastDate = date;

    return formattedDate;
  }
}

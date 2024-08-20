String convertToKoreanNumber(int number) {
  if (number < 0) return '음수는 지원하지 않습니다';

  // 조와 억 단위를 위한 변수
  int trillion = number ~/ 1000000000000; // 1조 단위
  int billion = (number % 1000000000000) ~/ 100000000; // 1억 단위

  List<String> parts = [];

  // 조 단위가 있는 경우 추가
  if (trillion > 0) {
    parts.add('$trillion조');
  }

  // 억 단위가 있는 경우 추가
  if (billion > 0) {
    parts.add('$billion억');
  }

  // 조와 억이 모두 없을 경우
  if (parts.isEmpty) {
    return '0';
  }

  return parts.join(' ');
}

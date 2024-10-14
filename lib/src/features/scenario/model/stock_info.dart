import 'package:intl/intl.dart';

class StockInfo {
  final DateTime date; // 날짜
  final int close; // 종가
  final int change; // 등락액
  final double percentChange; // 등락율
  final double eps; // 주당순이익
  final double per; // 주당순이익비율
  final int bps; // 주당순자산가치
  final double pbr; // 주당순자산가치비율
  final int dividendPerShare; // 주당 배당금
  final double dividendYield; // 배당수익률
  final double marketCap; // 시가총액

  StockInfo({
    required this.date,
    required this.close,
    required this.change,
    required this.percentChange,
    required this.eps,
    required this.per,
    required this.bps,
    required this.pbr,
    required this.dividendPerShare,
    required this.dividendYield,
    required this.marketCap,
  });

  factory StockInfo.fromCsv(List<String> csvRow) {
    return StockInfo(
      date: DateTime.parse(csvRow[0].replaceAll('.', '-')),
      close: int.parse(csvRow[1]),
      change: int.parse(csvRow[2]),
      percentChange: double.parse(csvRow[3]),
      eps: double.parse(csvRow[4]),
      per: double.parse(csvRow[5]),
      bps: int.parse(csvRow[6]),
      pbr: double.parse(csvRow[7]),
      dividendPerShare: int.parse(csvRow[8]),
      dividendYield: double.parse(csvRow[9]),
      marketCap: double.parse(csvRow[10]),
    );
  }

  factory StockInfo.fromList(List<dynamic> data) {
    return StockInfo(
      date: data[0] is DateTime
          ? data[0]
          : DateFormat('yyyy.M.d').parse(data[0].toString()),
      close: _toInt(data[1]),
      change: _toInt(data[2]),
      percentChange: _toDouble(data[3]),
      eps: _toDouble(data[4]),
      per: _toDouble(data[5]),
      bps: _toInt(data[6]),
      pbr: _toDouble(data[7]),
      dividendPerShare: _toInt(data[8]),
      dividendYield: _toDouble(data[9]),
      marketCap: _toDouble(data[10]),
    );
  }

  // 숫자 변환 헬퍼 함수
  static int _toInt(dynamic value) {
    return value is int ? value : int.tryParse(value.toString()) ?? 0;
  }

  static double _toDouble(dynamic value) {
    // 값이 null이거나 변환이 불가능할 경우 기본값 0.0 반환
    return (value is double || value is int)
        ? value.toDouble()
        : double.tryParse(value.toString()) ?? 0.0;
  }
}

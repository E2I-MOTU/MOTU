/*
  date: 해당 주식 데이터의 날짜를 나타냅니다. 보통 거래일을 의미합니다.
  open: 시가(開價)입니다. 해당 거래일의 첫 거래가격을 의미합니다.
  high: 고가(高價)입니다. 해당 거래일 중 가장 높았던 거래가격을 나타냅니다.
  low: 저가(低價)입니다. 해당 거래일 중 가장 낮았던 거래가격을 의미합니다.
  close: 종가(終價)입니다. 해당 거래일의 마지막 거래가격을 나타냅니다.
  adjClose: 수정 종가입니다.
  volume: 거래량입니다. 해당 거래일에 거래된 주식의 총 수량을 나타냅니다.
*/
import 'dart:developer';

import 'package:intl/intl.dart';

class StockData {
  StockData(
      {required this.x,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      required this.volume});

  final DateTime x;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  factory StockData.fromList(List<dynamic> data) {
    try {
      return StockData(
        x: data[0] is DateTime
            ? data[0]
            : DateFormat('yyyy-MM-dd').parse(data[0].toString()),
        open: data[1] is num
            ? data[1].toDouble()
            : double.parse(data[1].toString()),
        high: data[2] is num
            ? data[2].toDouble()
            : double.parse(data[2].toString()),
        low: data[3] is num
            ? data[3].toDouble()
            : double.parse(data[3].toString()),
        close: data[4] is num
            ? data[4].toDouble()
            : double.parse(data[4].toString()),
        volume:
            data[5] is num ? data[5].toInt() : int.parse(data[5].toString()),
      );
    } catch (e) {
      log('Error parsing StockData: $e');
      log('Problematic data: $data');
      rethrow;
    }
  }
}

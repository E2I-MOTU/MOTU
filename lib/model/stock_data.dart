/*
  date: 해당 주식 데이터의 날짜를 나타냅니다. 보통 거래일을 의미합니다.
  open: 시가(開價)입니다. 해당 거래일의 첫 거래가격을 의미합니다.
  high: 고가(高價)입니다. 해당 거래일 중 가장 높았던 거래가격을 나타냅니다.
  low: 저가(低價)입니다. 해당 거래일 중 가장 낮았던 거래가격을 의미합니다.
  close: 종가(終價)입니다. 해당 거래일의 마지막 거래가격을 나타냅니다.
  adjClose: 수정 종가입니다.
  volume: 거래량입니다. 해당 거래일에 거래된 주식의 총 수량을 나타냅니다.
*/
import 'package:intl/intl.dart';

class StockData {
  StockData(
      {required this.date,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      this.adjClose = 50,
      this.volume = 1000});

  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final double adjClose;
  final int volume;

  factory StockData.fromList(List<dynamic> data) {
    return StockData(
      date: data[0] is DateTime
          ? data[0]
          : DateFormat('yyyy-MM-dd').parse(data[0].toString()),
      open: data[1] is double ? data[1] : double.parse(data[1].toString()),
      high: data[2] is double ? data[2] : double.parse(data[2].toString()),
      low: data[3] is double ? data[3] : double.parse(data[3].toString()),
      close: data[4] is double ? data[4] : double.parse(data[4].toString()),
      adjClose: data[5] is double ? data[5] : double.parse(data[5].toString()),
      volume: data[6] is int ? data[6] : int.parse(data[6].toString()),
    );
  }
}

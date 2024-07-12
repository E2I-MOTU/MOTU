/*
  date: 해당 주식 데이터의 날짜를 나타냅니다. 보통 거래일을 의미합니다.
  open: 시가(開價)입니다. 해당 거래일의 첫 거래가격을 의미합니다.
  high: 고가(高價)입니다. 해당 거래일 중 가장 높았던 거래가격을 나타냅니다.
  low: 저가(低價)입니다. 해당 거래일 중 가장 낮았던 거래가격을 의미합니다.
  close: 종가(終價)입니다. 해당 거래일의 마지막 거래가격을 나타냅니다.
  adjClose: 수정 종가입니다.
  volume: 거래량입니다. 해당 거래일에 거래된 주식의 총 수량을 나타냅니다.
*/

class StockData {
  StockData(this.date, this.open, this.high, this.low, this.close,
      this.adjClose, this.volume);
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final double adjClose;
  final int volume;
}

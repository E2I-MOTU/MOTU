import 'package:motu/src/features/scenario/model/invest_record.dart';

class StockPortfolio {
  int initialBalance; // 시나리오 시작 당시 자본금
  int totalPurchasePrice; // 총 매수 금액
  int totalRatingPrice; // 총 평가 금액
  int unrealizedPnL; // 평가 손익
  int realizedPnL; // 실현 손익
  Map<String, List<int>> stocks = {
    '관련주 A': [0, 0],
    '관련주 B': [0, 0],
    '관련주 C': [0, 0],
    '관련주 D': [0, 0],
    '관련주 E': [0, 0],
  }; // [주식명: [보유량, 총 구매 금액]]
  List<InvestRecord> investRecords = []; // 투자 기록

  StockPortfolio({
    required this.initialBalance,
    required this.totalPurchasePrice,
    required this.totalRatingPrice,
    required this.unrealizedPnL,
    required this.realizedPnL,
    Map<String, List<int>>? stocks,
    List<InvestRecord>? investRecords,
  })  : stocks = stocks ??
            {
              '관련주 A': [0, 0],
              '관련주 B': [0, 0],
              '관련주 C': [0, 0],
              '관련주 D': [0, 0],
              '관련주 E': [0, 0],
            },
        investRecords = investRecords ?? [];

  factory StockPortfolio.fromJson(Map<String, dynamic> json) {
    return StockPortfolio(
      initialBalance: json['initialBalance'],
      totalPurchasePrice: json['totalPurchasePrice'],
      totalRatingPrice: json['totalRatingPrice'],
      unrealizedPnL: json['unrealizedPnL'],
      realizedPnL: json['realizedPnL'],
      stocks: json['stocks'],
      investRecords: json['investRecords'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'initialBalance': initialBalance,
      'totalPurchasePrice': totalPurchasePrice,
      'totalRatingPrice': totalRatingPrice,
      'unrealizedPnL': unrealizedPnL,
      'realizedPnL': realizedPnL,
      'stocks': stocks,
      'investRecords': investRecords,
    };
  }
}

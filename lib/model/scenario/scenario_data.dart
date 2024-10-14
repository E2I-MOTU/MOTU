import 'package:motu/model/scenario/stock_data.dart';
import 'package:motu/model/scenario/stock_financial.dart';
import 'package:motu/service/scenario_service.dart';

class ScenarioData {
  String selectedStock; // 선택된 주식
  Map<String, String>
      stockCSVPaths; // 주식별 CSV 파일 경로, 예: {'관련주 A': '0_chart.csv'}
  Map<String, List<StockData>>
      totalStockData; // 시나리오 기간 동안의 전체 데이터를 미리 저장해놓는 변수
  Map<String, List<StockData>>
      runningStockData; // 현재 진행중인 시나리오의 데이터를 미리 저장해놓는 변수
  Quarter currentQuarter = Quarter.first; // 현재 분기
  Map<Quarter, StockFinancial> financialData; // 각 분기별 재무재표
  Map<String, Map<String, dynamic>> totalNews; // 시나리오 기간 동안의 모든 뉴스

  ScenarioData({
    required this.selectedStock,
    required this.stockCSVPaths,
    required this.totalStockData,
    required this.runningStockData,
    required this.currentQuarter,
    required this.financialData,
    required this.totalNews,
  });

  factory ScenarioData.fromJson(Map<String, dynamic> json) {
    return ScenarioData(
      selectedStock: json['selectedStock'],
      stockCSVPaths: json['stockCSVPaths'],
      totalStockData: json['totalStockData'],
      runningStockData: json['runningStockData'],
      currentQuarter: json['currentQuarter'],
      financialData: json['financialData'],
      totalNews: json['totalNews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedStock': selectedStock,
      'stockCSVPaths': stockCSVPaths,
      'totalStockData': totalStockData,
      'runningStockData': runningStockData,
      'currentQuarter': currentQuarter,
      'financialData': financialData,
      'totalNews': totalNews,
    };
  }
}

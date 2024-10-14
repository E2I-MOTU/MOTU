import 'package:motu/src/features/scenario/model/scenario_data.dart';
import 'package:motu/src/features/scenario/model/stock_portfolio.dart';

class ScenarioStatus {
  DateTime terminatedAt; // 앱 Terminate 시간
  int totalRunningTime; // 시나리오 전체 러닝타임
  int globalTime; // 시나리오 전체 러닝타임 중 현재 시간
  ScenarioData runningScenario; // 현재 진행중인 시나리오
  StockPortfolio portfolio; // 보유 주식 포트폴리오

  ScenarioStatus({
    required this.terminatedAt,
    required this.totalRunningTime,
    required this.globalTime,
    required this.runningScenario,
    required this.portfolio,
  });

  factory ScenarioStatus.fromJson(Map<String, dynamic> json) {
    return ScenarioStatus(
      terminatedAt: json['terminatedAt'],
      totalRunningTime: json['totalRunningTime'],
      globalTime: json['globalTime'],
      runningScenario: ScenarioData.fromJson(json['runningScenario']),
      portfolio: StockPortfolio.fromJson(json['portfolio']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'terminatedAt': terminatedAt,
      'totalRunningTime': totalRunningTime,
      'globalTime': globalTime,
      'runningScenario': runningScenario.toJson(),
      'portfolio': portfolio.toJson(),
    };
  }
}

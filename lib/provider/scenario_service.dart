import 'dart:async';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

import '../model/stock_data.dart';

enum NoticeStatus { timer, news }

class ScenarioService extends ChangeNotifier {
  // 시나리오 남은 시간 타이머
  Timer? _remainingTimeTimer;
  Duration _remainingTime = Duration.zero;
  Duration get remainingTime => _remainingTime;

  int millisecondsPeriod = 1500;

  void startRemainingTimeTimer() {
    if (_storedAllStockData.isEmpty) return;

    int totalMilliseconds =
        (_storedAllStockData[_selectedStock]!.length * millisecondsPeriod)
            .toInt();
    _remainingTime = Duration(milliseconds: totalMilliseconds);

    _remainingTimeTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_remainingTime.inMilliseconds > 0) {
        _remainingTime -= const Duration(milliseconds: 100);
        notifyListeners();
      } else {
        _remainingTimeTimer?.cancel();
      }
    });
  }

  void stopRemainingTimeTimer() {
    _remainingTimeTimer?.cancel();
    _remainingTimeTimer = null;
  }

  // 메인 공지 상태 변수
  final NoticeStatus _status = NoticeStatus.timer;
  NoticeStatus get status => _status;

  // 안 본 뉴스 개수 상태 변수
  final int _unreadNewsCount = 1;
  int get unreadNewsCount => _unreadNewsCount;

  // 관련주 드롭다운
  String _selectedStock = '관련주 A';
  String get selectedStock => _selectedStock;

  // 관련주 변경
  void setSelectedStock(String value) {
    _selectedStock = value;
    _updateVisibleStockData();

    updateYAxisRangeLast21Data();

    notifyListeners();
  }

  final List<String> stockOptions = [
    '관련주 A',
    '관련주 B',
    '관련주 C',
    '관련주 D',
    '관련주 E'
  ];

  final Map<String, String> stockCSVPaths = {
    '관련주 A': 'economic_recovery_scenario/AAPL_economic_recovery_scenario.csv',
    '관련주 B': 'economic_recovery_scenario/GOOGL_economic_recovery_scenario.csv',
    '관련주 C': 'economic_recovery_scenario/MSFT_economic_recovery_scenario.csv',
    '관련주 D': 'economic_recovery_scenario/AMZN_economic_recovery_scenario.csv',
    '관련주 E': 'economic_recovery_scenario/TSLA_economic_recovery_scenario.csv',
  };

  // y축, x축 범위 변수
  double yMinimum = 0;
  double yMaximum = 100;
  double yInterval = 10;

  DateTime xMinimum = DateTime.now().subtract(const Duration(days: 21));
  DateTime xMaximum = DateTime.now();

  final Map<String, List<StockData>> _storedAllStockData = {};
  Map<String, List<StockData>> get storedAllStockData => _storedAllStockData;

  final Map<String, List<StockData>> _visibleAllStockData = {};
  List<StockData> _visibleStockData = [];
  List<StockData> get visibleStockData => _visibleStockData;

// 글로벌 타이머 및 인덱스
  Timer? _globalTimer;
  int _globalIndex = 20;

  void startDataUpdate() {
    _globalTimer =
        Timer.periodic(Duration(milliseconds: millisecondsPeriod), (timer) {
      _updateAllVisibleData();
    });
  }

  void stopDataUpdate() {
    _globalTimer?.cancel();
    _globalTimer = null;
  }

  void _updateAllVisibleData() {
    bool allDataDisplayed = true;

    for (final stock in stockOptions) {
      if (_globalIndex < _storedAllStockData[stock]!.length - 1) {
        _visibleAllStockData[stock] =
            _storedAllStockData[stock]!.sublist(0, _globalIndex + 1);
        allDataDisplayed = false;
      } else {
        _visibleAllStockData[stock] = _storedAllStockData[stock]!;
      }
    }

    if (!allDataDisplayed) {
      _globalIndex++;
    }

    // 선택된 주식의 visibleStockData 업데이트
    _updateVisibleStockData();

    if (allDataDisplayed) {
      stopDataUpdate(); // 모든 데이터를 표시했으면 타이머 중지
    }

    notifyListeners();
  }

// Initialize
  ScenarioService() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    log("Data initialized");

    // 모든 관련주 데이터 불러오기
    await _loadAllData();

    // 불러온 데이터를 바탕으로 초기 데이터 설정 (21일 데이터)
    _initializeVisibleData();

    // selectedStock에 따라 visibleStockData 설정
    _updateVisibleStockData();

    // y축 범위 설정
    updateYAxisRangeLast21Data();

    // 주식 차트 타이머 시작
    startDataUpdate();

    // 남은 시간 타이머 시작
    startRemainingTimeTimer();

    notifyListeners();
  }

  Future<void> _loadAllData() async {
    for (final stock in stockOptions) {
      await _loadDataForStock(stock);
    }
  }

  Future<void> _loadDataForStock(String stock) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final pathRef = storageRef.child(stockCSVPaths[stock]!);

      final url = await pathRef.getDownloadURL();
      final response = await http.get(Uri.parse(url)); // http.get 사용

      if (response.statusCode == 200) {
        final csvString = response.body;
        // CSV Data
        List<List<dynamic>> csvStockData =
            const CsvToListConverter().convert(csvString, eol: '\n');

        _storedAllStockData[stock] = _parseCSVToStockData(csvStockData);

        notifyListeners();
      } else {
        throw Exception('Failed to load CSV file for $stock');
      }
    } catch (e) {
      log('Error loading data for $stock : $e');
    }
  }

  List<StockData> _parseCSVToStockData(List<List<dynamic>> csvData) {
    // 첫 번째 행(헤더)을 제거합니다.
    csvData.removeAt(0);

    return csvData.map((row) => StockData.fromList(row)).toList();
  }

  void _initializeVisibleData() {
    for (final stock in stockOptions) {
      if (_storedAllStockData.containsKey(stock)) {
        final stockData = _storedAllStockData[stock]!;
        final int endIndex = stockData.length < 21 ? stockData.length : 21;
        _visibleAllStockData[stock] = stockData.sublist(0, endIndex);
      } else {
        // 해당 주식 데이터가 없는 경우 빈 리스트로 초기화
        _visibleAllStockData[stock] = [];
      }
    }
  }

  void _updateVisibleStockData() {
    if (_visibleAllStockData.containsKey(_selectedStock)) {
      _visibleStockData = List.from(_visibleAllStockData[_selectedStock]!);
    } else {
      _visibleStockData = [];
    }

    notifyListeners();
  }

  void updateYAxisRange(ActualRangeChangedArgs args) {
    if (_visibleStockData.isEmpty) return;

    // 현재 보이는 x축 범위
    final xMin = args.visibleMin;
    final xMax = args.visibleMax;

    // x축 범위 내의 데이터 필터링
    var filteredData = _visibleStockData.where((data) {
      double dataXAsDouble =
          data.x.millisecondsSinceEpoch.toDouble(); // DateTime을 double로 변환
      return dataXAsDouble >= xMin && dataXAsDouble <= xMax;
    }).toList();

    if (filteredData.isEmpty) return; // 필터링된 데이터가 없을 경우 종료

    // 현재 보이는 데이터의 최소값과 최대값을 찾습니다.
    double minLow =
        filteredData.map((data) => data.low).reduce((a, b) => a < b ? a : b);
    double maxHigh =
        filteredData.map((data) => data.high).reduce((a, b) => a > b ? a : b);

    // 값의 범위를 계산합니다.
    double range = maxHigh - minLow;

    // 최소값과 최대값에 여유 공간을 추가합니다 (전체 범위의 10%).
    double padding = range * 0.1;
    yMinimum = (minLow - padding).floorToDouble();
    yMaximum = (maxHigh + padding).ceilToDouble();

    // 간격을 계산합니다. 대략 5-7개의 간격이 생기도록 합니다.
    double rawInterval = range / 6;

    // 간격을 적절한 값으로 반올림합니다.
    if (rawInterval > 10) {
      yInterval = (rawInterval / 10).round() * 10.0;
    } else if (rawInterval > 1) {
      yInterval = (rawInterval).round().toDouble();
    } else {
      yInterval = (rawInterval * 10).round() / 10;
    }

    // yMinimum, yMaximum, yInterval 값을 업데이트한 후 리스너를 통지합니다.
    notifyListeners();
  }

  void updateYAxisRangeLast21Data() {
    if (_visibleStockData.isEmpty) return;

    // 전체 데이터에서 최근 21개의 데이터만 가져옵니다.
    var last21Data = _visibleStockData.length > 21
        ? _visibleStockData.sublist(_visibleStockData.length - 21)
        : _visibleStockData;

    if (last21Data.isEmpty) return; // 데이터가 없을 경우 종료

    // 최근 21개 데이터의 최소값과 최대값을 찾습니다.
    double minLow =
        last21Data.map((data) => data.low).reduce((a, b) => a < b ? a : b);
    double maxHigh =
        last21Data.map((data) => data.high).reduce((a, b) => a > b ? a : b);

    // 값의 범위를 계산합니다.
    double range = maxHigh - minLow;

    // 최소값과 최대값에 여유 공간을 추가합니다 (전체 범위의 10%).
    double padding = range * 0.1;
    yMinimum = (minLow - padding).floorToDouble();
    yMaximum = (maxHigh + padding).ceilToDouble();

    // 간격을 계산합니다. 대략 5-7개의 간격이 생기도록 합니다.
    double rawInterval = range / 6;

    // 간격을 적절한 값으로 반올림합니다.
    if (rawInterval > 10) {
      yInterval = (rawInterval / 10).round() * 10.0;
    } else if (rawInterval > 1) {
      yInterval = (rawInterval).round().toDouble();
    } else {
      yInterval = (rawInterval * 10).round() / 10;
    }

    // yMinimum, yMaximum, yInterval 값을 업데이트한 후 리스너를 통지합니다.
    notifyListeners();
  }

  @override
  void dispose() {
    stopDataUpdate();
    stopRemainingTimeTimer();
    super.dispose();
  }
}

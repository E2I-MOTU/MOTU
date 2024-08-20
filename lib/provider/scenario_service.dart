import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:motu/model/stock_financial.dart';
import 'package:motu/model/stock_info.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

import '../model/stock_data.dart';

enum NoticeStatus { timer, news }

enum ScenarioType {
  covid,
  inflation,
  interestRate,
  unemployment,
  gdp,
}

enum Quarter {
  first,
  second,
  third,
  fourth,
}

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

  late DateTime currentStockTime;

  // 메인 공지 상태 변수
  final NoticeStatus _status = NoticeStatus.timer;
  NoticeStatus get status => _status;

  // 안 본 뉴스 개수 상태 변수
  final int _unreadNewsCount = 1;
  int get unreadNewsCount => _unreadNewsCount;

  // 선택한 시나리오 타입
  ScenarioType? _selectedScenario;
  ScenarioType? get selectedScenario => _selectedScenario;
  void setSelectedScenario(ScenarioType scenario) {
    _selectedScenario = scenario;
    notifyListeners();
  }

  // 관련주 드롭다운
  String _selectedStock = '관련주 A';
  String get selectedStock => _selectedStock;

  // 관련주 변경
  void setSelectedStock(String value) {
    _selectedStock = value;
    dev.log("Selected Stock ID: ${_stockCSVPaths[_selectedStock]![0]}");

    _updateVisibleStockData();

    updateYAxisRange(_actualArgs);

    notifyListeners();
  }

  List<String> stockOptions = [
    '관련주 A',
    '관련주 B',
    '관련주 C',
    '관련주 D',
    '관련주 E',
  ];

  Map<String, String> _stockCSVPaths = {}; // 예: {'관련주 A': '0_chart.csv'}
  Map<String, String> get stockCSVPaths => _stockCSVPaths;

  // 현재 ActualRangeChangedArgs 척도
  ActualRangeChangedArgs _actualArgs = ActualRangeChangedArgs();
  ActualRangeChangedArgs get actualArgs => _actualArgs;
  void setActualArgs(ActualRangeChangedArgs args) {
    _actualArgs = args;
    notifyListeners();
  }

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
    dev.log("Data initialized");

    // 모든 관련주 데이터 불러오기
    await _loadAllData();

    // 불러온 데이터를 바탕으로 초기 데이터 설정 (21일 데이터)
    _initializeVisibleData();

    // selectedStock에 따라 visibleStockData 설정
    _updateVisibleStockData();

    // y축 범위 설정
    updateYAxisRangeLastData();

    // 주식 차트 타이머 시작
    startDataUpdate();

    // 남은 시간 타이머 시작
    startRemainingTimeTimer();

    notifyListeners();
  }

  Future<void> _loadAllData() async {
    List<String> storageFiles = [];
    try {
      final storage = FirebaseStorage.instance.ref();
      final chartPathRef = storage.child('scenario/covid/chart/');
      final ListResult result = await chartPathRef.listAll();

      for (var item in result.items) {
        storageFiles.add(item.name);
      }

      // 랜덤 선택을 위한 Random 객체 생성
      Random random = Random();

      // 리스트에서 랜덤으로 5개 선택
      List<String> randomSelectedFiles = List.from(storageFiles)
        ..shuffle(random);
      randomSelectedFiles = randomSelectedFiles.sublist(0, 5);

      _stockCSVPaths = {
        "관련주 A": randomSelectedFiles[0],
        "관련주 B": randomSelectedFiles[1],
        "관련주 C": randomSelectedFiles[2],
        "관련주 D": randomSelectedFiles[3],
        "관련주 E": randomSelectedFiles[4],
      };

      // dev.log('Loaded stock CSV paths: $_stockCSVPaths');

      // Isolate를 사용하여 멀티스레드로 데이터 로드
      List<Future<void>> futures = stockOptions.map((stock) async {
        await _loadDataForStock(stock);
        await _loadInfoForStock(stock);
        await _loadFinancialForStock(stock);
      }).toList();

      await Future.wait(futures); // 모든 작업이 완료될 때까지 기다립니다.
    } catch (e) {
      dev.log('Unexpected error: $e');
    }
  }

  Future<void> _loadDataForStock(String stock) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      Reference pathRef;
      switch (_selectedScenario) {
        case ScenarioType.covid:
          pathRef =
              storageRef.child("scenario/covid/chart/${stockCSVPaths[stock]!}");
          break;
        case ScenarioType.inflation:
          pathRef = storageRef
              .child("scenario/inflation/chart/${stockCSVPaths[stock]!}");
          break;
        case ScenarioType.interestRate:
          pathRef = storageRef
              .child("scenario/interestRate/chart/${stockCSVPaths[stock]!}");
          break;
        case ScenarioType.unemployment:
          pathRef = storageRef
              .child("scenario/unemployment/chart/${stockCSVPaths[stock]!}");
          break;
        case ScenarioType.gdp:
          pathRef =
              storageRef.child("scenario/gdp/chart/${stockCSVPaths[stock]!}");
          break;
        default:
          throw Exception('Invalid scenario type');
      }

      final url = await pathRef.getDownloadURL();
      final response = await http.get(Uri.parse(url)); // http.get 사용

      if (response.statusCode == 200) {
        String csvString = response.body;

        // CSV Data
        List<List<dynamic>> csvStockData =
            const CsvToListConverter().convert(csvString, eol: '\n');

        _storedAllStockData[stock] = _parseCSVToStockData(csvStockData);
        dev.log('Loaded CSV file for $stock chart');

        notifyListeners();
      } else {
        throw Exception('Failed to load CSV file for $stock');
      }
    } catch (e) {
      dev.log('Error loading data for $stock : $e');
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
      currentStockTime = _visibleStockData.last.x;
      if (q01Financial.year == 1900) {
        q01Financial.year = currentStockTime.year;
        q02Financial.year = currentStockTime.year;
        q03Financial.year = currentStockTime.year;
        q04Financial.year = currentStockTime.year;
      }
      updateCurrentStockInfo();

      // 분기 별 정보 업데이트
      int month = currentStockTime.month;
      if (month >= 1 && month <= 3) {
        // if (currentQuarter == Quarter.fourth) {
        //   q01Financial = resetQuarterFinancialData();
        //   q02Financial = resetQuarterFinancialData();
        //   q03Financial = resetQuarterFinancialData();
        //   q04Financial = resetQuarterFinancialData();
        // }
        currentQuarter = Quarter.first;
      } else if (month >= 4 && month <= 6) {
        currentQuarter = Quarter.second;
      } else if (month >= 7 && month <= 9) {
        currentQuarter = Quarter.third;
      } else {
        currentQuarter = Quarter.fourth;
      }

      updateQuarterFinancialData();
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

    // 최소값과 최대값에 여유 공간을 추가합니다 (전체 범위의 20%).
    double padding = range * 0.2;
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

  void updateYAxisRangeLastData() {
    if (_visibleStockData.isEmpty) return;

    // 전체 데이터에서 최근 21개의 데이터만 가져옵니다.
    List<StockData> lastData = _visibleStockData.length > 21
        ? _visibleStockData.sublist(_visibleStockData.length - 21)
        : _visibleStockData;

    if (lastData.length < 2) return; // 데이터가 없을 경우 종료

    // 최근 21개 데이터의 최소값과 최대값을 찾습니다.
    double minLow =
        lastData.map((data) => data.low).reduce((a, b) => a < b ? a : b);
    double maxHigh =
        lastData.map((data) => data.high).reduce((a, b) => a > b ? a : b);

    // 값의 범위를 계산합니다.
    double range = maxHigh - minLow;

    // 최소값과 최대값에 여유 공간을 추가합니다 (전체 범위의 10%).
    double padding = range * 0.2;
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

  //*---------------------------------------------------------------------------
  //* MARK: - 관련주 당 주식 종목 정보

  final Map<String, List<StockInfo>> _stockDataInfo = {};
  get stockDataInfo => _stockDataInfo;
  void setStockDataInfo(String stock, List<StockInfo> stockInfo) {
    _stockDataInfo[stock] = stockInfo;
    notifyListeners();
  }

  StockInfo currentStockInfo = StockInfo(
    date: DateTime.now(),
    close: 0,
    change: 0,
    percentChange: 0,
    eps: 0,
    per: 0,
    bps: 0,
    pbr: 0,
    dividendPerShare: 0,
    dividendYield: 0,
    marketCap: 0,
  );

  void updateCurrentStockInfo() {
    if (_stockDataInfo.containsKey(_selectedStock)) {
      List<StockInfo> stockInfo = _stockDataInfo[_selectedStock]!;
      currentStockInfo = stockInfo.firstWhere(
        (element) => element.date == currentStockTime,
        orElse: () => StockInfo(
          date: DateTime.now(),
          close: 0,
          change: 0,
          percentChange: 0,
          eps: 0,
          per: 0,
          bps: 0,
          pbr: 0,
          dividendPerShare: 0,
          dividendYield: 0,
          marketCap: 0,
        ),
      );
    } else {
      currentStockInfo = StockInfo(
        date: DateTime.now(),
        close: 0,
        change: 0,
        percentChange: 0,
        eps: 0,
        per: 0,
        bps: 0,
        pbr: 0,
        dividendPerShare: 0,
        dividendYield: 0,
        marketCap: 0,
      );
    }

    notifyListeners();
  }

  List<StockInfo> _parseCSVToStockInfo(List<List<dynamic>> csvData) {
    // 첫 번째 행(헤더)을 제거합니다.
    csvData.removeAt(0);

    return csvData.map((row) => StockInfo.fromList(row)).toList();
  }

  Future<void> _loadInfoForStock(String stock) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      Reference pathRef;
      String stockID = stockCSVPaths[stock]![0];
      switch (_selectedScenario) {
        case ScenarioType.covid:
          pathRef = storageRef.child("scenario/covid/info/${stockID}_info.csv");
          break;
        case ScenarioType.inflation:
          pathRef =
              storageRef.child("scenario/inflation/info/${stockID}_info.csv");
          break;
        case ScenarioType.interestRate:
          pathRef = storageRef
              .child("scenario/interestRate/info/${stockID}_info.csv");
          break;
        case ScenarioType.unemployment:
          pathRef = storageRef
              .child("scenario/unemployment/info/${stockID}_info.csv");
          break;
        case ScenarioType.gdp:
          pathRef = storageRef.child("scenario/gdp/info/${stockID}_info.csv");
          break;
        default:
          throw Exception('Invalid scenario type');
      }

      final url = await pathRef.getDownloadURL();
      final response = await http.get(Uri.parse(url)); // http.get 사용

      if (response.statusCode == 200) {
        String csvString = response.body;

        // CSV Data
        List<List<dynamic>> csvStockData =
            const CsvToListConverter().convert(csvString, eol: '\n');

        _stockDataInfo[stock] = _parseCSVToStockInfo(csvStockData);

        dev.log('Loaded CSV file for $stock info');

        notifyListeners();
      } else {
        throw Exception('Failed to load CSV file for $stock');
      }
    } catch (e) {
      dev.log('Error loading data for $stock : $e');
    }
  }

  //* MARK: 관련주 당 분기별 정보

  final Map<String, List<StockFinancial>> _stockDataFinancial = {};
  get stockDataFinancial => _stockDataFinancial;
  void setStockDataFinancial(
      String stock, List<StockFinancial> stockFinancial) {
    _stockDataFinancial[stock] = stockFinancial;
    notifyListeners();
  }

  Quarter currentQuarter = Quarter.first;

  StockFinancial q01Financial = StockFinancial(
    year: 1900,
    quarter: '',
    revenue: -1,
    netIncome: -1,
    totalAssets: -1,
    totalLiabilities: -1,
  );
  StockFinancial q02Financial = StockFinancial(
    year: 1900,
    quarter: '',
    revenue: -1,
    netIncome: -1,
    totalAssets: -1,
    totalLiabilities: -1,
  );
  StockFinancial q03Financial = StockFinancial(
    year: 1900,
    quarter: '',
    revenue: -1,
    netIncome: -1,
    totalAssets: -1,
    totalLiabilities: -1,
  );
  StockFinancial q04Financial = StockFinancial(
    year: 1900,
    quarter: '',
    revenue: -1,
    netIncome: -1,
    totalAssets: -1,
    totalLiabilities: -1,
  );

  List<StockFinancial> _parseCSVToStockFinancial(List<List<dynamic>> csvData) {
    // 첫 번째 행(헤더)을 제거합니다.
    csvData.removeAt(0);
    return csvData.map((row) => StockFinancial.fromList(row)).toList();
  }

  Future<void> _loadFinancialForStock(String stock) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      Reference pathRef;
      String stockID = stockCSVPaths[stock]![0];
      switch (_selectedScenario) {
        case ScenarioType.covid:
          pathRef = storageRef
              .child("scenario/covid/financial/${stockID}_financial.csv");
          break;
        case ScenarioType.inflation:
          pathRef = storageRef
              .child("scenario/inflation/financial/${stockID}_financial.csv");
          break;
        case ScenarioType.interestRate:
          pathRef = storageRef.child(
              "scenario/interestRate/financial/${stockID}_financial.csv");
          break;
        case ScenarioType.unemployment:
          pathRef = storageRef.child(
              "scenario/unemployment/financial/${stockID}_financial.csv");
          break;
        case ScenarioType.gdp:
          pathRef = storageRef
              .child("scenario/gdp/financial/${stockID}_financial.csv");
          break;
        default:
          throw Exception('Invalid scenario type');
      }

      final url = await pathRef.getDownloadURL();
      final response = await http.get(Uri.parse(url)); // http.get 사용

      if (response.statusCode == 200) {
        String csvString = response.body;

        // CSV Data
        List<List<dynamic>> csvStockData =
            const CsvToListConverter().convert(csvString, eol: '\n');

        _stockDataFinancial[stock] = _parseCSVToStockFinancial(csvStockData);

        dev.log('Loaded CSV file for $stock financial');

        notifyListeners();
      } else {
        throw Exception('Failed to load CSV file for $stock');
      }
    } catch (e) {
      dev.log('Error loading data for $stock : $e');
    }
  }

  StockFinancial resetQuarterFinancialData() {
    return StockFinancial(
      year: currentStockTime.year - 1,
      quarter: '',
      revenue: -1,
      netIncome: -1,
      totalAssets: -1,
      totalLiabilities: -1,
    );
  }

  void updateQuarterFinancialData() {
    List<StockFinancial> thisYearData;

    switch (currentQuarter) {
      case Quarter.first:
        thisYearData = _stockDataFinancial[_selectedStock]!
            .where((data) => data.year == currentStockTime.year - 1)
            .toList();
        q04Financial = thisYearData.firstWhere(
          (element) => element.quarter == 'Q12',
          orElse: () => StockFinancial(
            year: currentStockTime.year,
            quarter: 'Q12',
            revenue: -1,
            netIncome: -1,
            totalAssets: -1,
            totalLiabilities: -1,
          ),
        );
        break;
      case Quarter.second:
        thisYearData = _stockDataFinancial[_selectedStock]!
            .where((data) => data.year == currentStockTime.year)
            .toList();
        q01Financial = thisYearData.firstWhere(
          (element) => element.quarter == 'Q03',
          orElse: () => StockFinancial(
            year: currentStockTime.year,
            quarter: 'Q03',
            revenue: -1,
            netIncome: -1,
            totalAssets: -1,
            totalLiabilities: -1,
          ),
        );

        break;
      case Quarter.third:
        thisYearData = _stockDataFinancial[_selectedStock]!
            .where((data) => data.year == currentStockTime.year)
            .toList();
        q02Financial = thisYearData.firstWhere(
          (element) => element.quarter == 'Q06',
          orElse: () => StockFinancial(
            year: currentStockTime.year,
            quarter: 'Q06',
            revenue: -1,
            netIncome: -1,
            totalAssets: -1,
            totalLiabilities: -1,
          ),
        );

        break;
      case Quarter.fourth:
        thisYearData = _stockDataFinancial[_selectedStock]!
            .where((data) => data.year == currentStockTime.year)
            .toList();
        q03Financial = thisYearData.firstWhere(
          (element) => element.quarter == 'Q09',
          orElse: () => StockFinancial(
            year: currentStockTime.year,
            quarter: 'Q09',
            revenue: -1,
            netIncome: -1,
            totalAssets: -1,
            totalLiabilities: -1,
          ),
        );

        break;
    }
  }
}

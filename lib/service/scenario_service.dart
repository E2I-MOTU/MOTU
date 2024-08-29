import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:motu/model/invest_record.dart';
import 'package:motu/model/stock_financial.dart';
import 'package:motu/model/stock_info.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

import '../model/stock_data.dart';
import '../model/stock_news.dart';

enum NoticeStatus { timer, news }

enum ScenarioType {
  covid,
  war,
}

enum TransactionType {
  buy,
  sell,
}

enum Quarter {
  first,
  second,
  third,
  fourth,
}

class ScenarioService extends ChangeNotifier {
  // MARK: - 시나리오 남은 시간 타이머
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

  bool _isChangeStock = false;
  bool get isChangeStock => _isChangeStock;
  void setIsChangeStock(bool value) {
    _isChangeStock = value;
    notifyListeners();
  }

  // 관련주 변경
  void setSelectedStock(String value) {
    _selectedStock = value;
    dev.log("Selected Stock ID: ${_stockCSVPaths[_selectedStock]![0]}");

    _updateAllVisibleData();

    updateYAxisRange(_actualArgs);

    setIsChangeStock(true);

    // 2초 후에 isChangeStock을 false로 변경
    Future.delayed(const Duration(seconds: 2), () {
      setIsChangeStock(false);
    });

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
  Map<String, List<StockData>> get visibleAllStockData => _visibleAllStockData;
  List<StockData> _visibleStockData = [];
  List<StockData> get visibleStockData => _visibleStockData;

// MARK: - 글로벌 타이머 및 인덱스
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

    try {
      // 선택된 주식의 visibleStockData 업데이트
      _updateVisibleStockData();
    } catch (e) {
      dev.log('Error updating visible stock data: $e');
    }

    if (allDataDisplayed) {
      stopDataUpdate(); // 모든 데이터를 표시했으면 타이머 중지
    }

    notifyListeners();
  }

// MARK: - Initialize
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
        await _loadNewsForStock();
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
        case ScenarioType.war:
          pathRef =
              storageRef.child("scenario/war/chart/${stockCSVPaths[stock]!}");
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

  // MARK: - 시간 관리하는 부분
  void _updateVisibleStockData() {
    dev.log("Updating visible stock data for $_selectedStock");
    if (_visibleAllStockData.containsKey(_selectedStock)) {
      _visibleStockData = _visibleAllStockData[_selectedStock]!;

      // 데이터가 비어있지 않은지 확인
      currentStockTime = _visibleStockData.last.x;
      if (q01Financial.year == 1900) {
        q01Financial.year = currentStockTime.year;
        q02Financial.year = currentStockTime.year;
        q03Financial.year = currentStockTime.year;
        q04Financial.year = currentStockTime.year;
      }

      // 뉴스 데이터 업데이트
      List<String> toRemove = [];
      for (String newsDate in _allNewsKeys) {
        DateTime newsDateTime = DateTime.parse(newsDate);
        String formattedNewsDate =
            '${newsDateTime.year.toString().padLeft(4, '0')}-${newsDateTime.month.toString().padLeft(2, '0')}-${newsDateTime.day.toString().padLeft(2, '0')}';

        if (newsDateTime.isBefore(currentStockTime)) {
          toRemove.add(newsDate);

          Timestamp timestamp = _allNews[formattedNewsDate]["date"];
          DateTime date = timestamp.toDate();

          StockNews news = StockNews(
            title: _allNews[formattedNewsDate]["title"],
            content: _allNews[formattedNewsDate]["content"],
            imageURL: _allNews[formattedNewsDate]["imageUrl"],
            date: DateTime(date.year, date.month, date.day),
          );

          _news.add(news);

          notifyListeners();
        }
      }
      for (String key in toRemove) {
        _allNewsKeys.remove(key);
      }

      // 현재 주식 종목 정보 업데이트
      updateCurrentStockInfo();

      // 현재 보유한 주식의 총 투자 금액 업데이트
      updateTotalRatingPrice();

      // 현재 보유한 주식의 총 평가 금액 업데이트
      updateUnrealizedPnL();

      // 분기 별 정보 업데이트
      int month = currentStockTime.month;
      if (month >= 1 && month <= 3) {
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
      dev.log('Warning: No data found for $_selectedStock');
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

    if (filteredData.length < 2) return; // 필터링된 데이터가 없을 경우 종료

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

  String explainTextbyCell(String cell) {
    String explainText = "";
    if (cell == "매출액") {
      explainText =
          "매출액은 기업이 판매한 상품이나 용역에 대한 대가로 받은 금액입니다. \n\n매출액 = 판매량 x 판매가격";
    }
    if (cell == "영업이익") {
      explainText =
          "영업이익은 기업이 영업활동을 통해 얻은 이익입니다. \n\n영업이익 = 매출액 - 매출원가 - 판매비와 관리비";
    }
    if (cell == "당기순이익") {
      explainText = "당기순이익은 기업이 당기에 얻은 순이익입니다. \n\n당기순이익 = 영업이익 - 이자비용 - 세금";
    }
    if (cell == "자산총계") {
      explainText = "자산총계는 기업이 보유한 자산의 총액입니다. \n\n자산총계 = 유동자산 + 비유동자산";
    }
    if (cell == "부채총계") {
      explainText = "부채총계는 기업이 부담해야 하는 총부채의 총액입니다. \n\n부채총계 = 유동부채 + 비유동부채";
    }
    return explainText;
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
        case ScenarioType.war:
          pathRef = storageRef.child("scenario/war/info/${stockID}_info.csv");
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
        case ScenarioType.war:
          pathRef = storageRef
              .child("scenario/war/financial/${stockID}_financial.csv");
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

  //*---------------------------------------------------------------------------
  //* MARK: - 뉴스탭 관련
  Map<String, dynamic> _allNews = {};
  List<String> _allNewsKeys = [];
  final List<StockNews> _news = [];
  List<StockNews> get news => _news;

  List<StockNews> sortNewsList() {
    return List<StockNews>.from(news)
      ..sort((a, b) {
        if (a.isRead == b.isRead) return 0;
        return a.isRead ? 1 : -1;
      });
  }

  Future<void> _loadNewsForStock() async {
    try {
      final instance = FirebaseFirestore.instance;
      final collection = instance.collection('scenario');
      late DocumentSnapshot doc;

      switch (_selectedScenario) {
        case ScenarioType.covid:
          doc = await collection.doc('covid').get();
          break;
        case ScenarioType.war:
          doc = await collection.doc('war').get();
          break;
        default:
      }

      if (doc.exists) {
        _allNews = doc.data() as Map<String, dynamic>;
        _allNewsKeys = _allNews.keys.toList();

        dev.log('Loaded firestore news data');
        notifyListeners();
      }
    } catch (e) {
      dev.log('Error loading news : $e');
    }
  }

  int checkUnreadNews() {
    int unreadCount = 0;
    for (StockNews news in _news) {
      if (!news.isRead) {
        unreadCount++;
      }
    }
    return unreadCount;
  }

  // MARK: - 보유 주식 데이터
  int totalPurchasePrice = 0; // 총 구매 금액

  int totalRatingPrice = 0; // 평가 금액

  int unrealizedPnL = 0; // 평가 손익

  int realizedPnL = 0; // 실현 손익

  final Map<String, List<int>> _investStocks = {
    '관련주 A': [0, 0],
    '관련주 B': [0, 0],
    '관련주 C': [0, 0],
    '관련주 D': [0, 0],
    '관련주 E': [0, 0],
  };
  Map<String, List<int>> get investStocks => _investStocks;
  void setInvestStocks(String stock, TransactionType type, int amount) {
    int currentAmount = _investStocks[stock]![0];
    if (type == TransactionType.buy) {
      _investStocks[stock]![0] = currentAmount + amount;
    } else {
      _investStocks[stock]![0] = currentAmount - amount;
    }

    int currentTotalPrice = _investStocks[stock]![1];
    int price = _visibleAllStockData[stock]!.last.close.toInt();
    if (type == TransactionType.buy) {
      _investStocks[stock]![1] = currentTotalPrice + price * amount;
    } else {
      _investStocks[stock]![1] = currentTotalPrice - price * amount;
    }

    notifyListeners();
  }

  bool checkInvested() {
    for (String stock in _investStocks.keys) {
      if (_investStocks[stock]![0] != 0) {
        return true;
      }
    }
    return false;
  }

  final List<InvestRecord> _investRecords = [];
  List<InvestRecord> get investRecords => _investRecords;
  void setInvestRecords(InvestRecord record) {
    _investRecords.add(record);

    notifyListeners();
  }

  void updateTotalRatingPrice() {
    int total = 0;
    for (String stock in _investStocks.keys) {
      total += _investStocks[stock]![0] *
          visibleAllStockData[stock]!.last.close.toInt();
    }
    totalRatingPrice = total;

    notifyListeners();
  }

  void updateTotalPurchasePrice() {
    int total = 0;
    for (String stock in _investStocks.keys) {
      total += _investStocks[stock]![1];
    }
    totalPurchasePrice = total;

    notifyListeners();
  }

  void updateUnrealizedPnL() {
    int total = 0;
    for (String stock in _investStocks.keys) {
      int currentValue = _investStocks[stock]![0] *
          visibleAllStockData[stock]!.last.close.toInt();
      int purchaseValue = _investStocks[stock]![1];
      total += (currentValue - purchaseValue);
    }

    unrealizedPnL = total;

    notifyListeners();
  }

  void updateRealizedPnL(InvestRecord record) {
    int averagePrice =
        _investStocks[selectedStock]![1] ~/ _investStocks[selectedStock]![0];
    int currentPrice = visibleAllStockData[selectedStock]!.last.close.toInt();
    int amount = record.amount;

    if (record.type == TransactionType.sell) {
      realizedPnL += (currentPrice - averagePrice) * amount;
    }
    dev.log('This Realized PnL: ${(currentPrice - averagePrice) * amount}}');

    notifyListeners();
  }
}

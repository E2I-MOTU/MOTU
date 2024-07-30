import 'dart:async';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/stock_data.dart';

class ScenarioService extends ChangeNotifier {
  // Data
  List<StockData> _stockDataList = [];
  List<StockData> get stockDataList => _stockDataList;

  final List<StockData> _displayedStockDataList = [];
  List<StockData> get displayedStockDataList => _displayedStockDataList;

  // Trackball
  late TrackballBehavior _trackballBehavior;
  TrackballBehavior get trackballBehavior => _trackballBehavior;

  // Panning
  late bool _isLoadMoreView, _isNeedToUpdateView, _isDataUpdated;
  bool get isLoadMoreView => _isLoadMoreView;
  bool get isNeedToUpdateView => _isNeedToUpdateView;
  bool get isDataUpdated => _isDataUpdated;

  // Zoom
  late ZoomPanBehavior _zoomPanBehavior;
  ZoomPanBehavior get zoomPanBehavior => _zoomPanBehavior;

  // X축
  late DateTimeAxis _primaryXAxis;
  DateTimeAxis get primaryXAxis => _primaryXAxis;

  // Y축
  late double _yAxisMinimum;
  double get yAxisMinimum => _yAxisMinimum;
  late double _yAxisMaximum;
  double get yAxisMaximum => _yAxisMaximum;
  late double _yAxisInterval;
  double get yAxisInterval => _yAxisInterval;

  DateTime _visibleMinimum = DateTime.now().subtract(const Duration(days: 21));
  DateTime _visibleMaximum = DateTime.now();
  DateTime get visibleMinimum => _visibleMinimum;
  DateTime get visibleMaximum => _visibleMaximum;

  void setVisibleMinimum(DateTime value) {
    _visibleMinimum = value;
    notifyListeners();
  }

  void setVisibleMaximum(DateTime value) {
    _visibleMaximum = value;
    notifyListeners();
  }

  bool get isDataLoaded => _isDataLoaded;
  bool _isDataLoaded = false;

  int _currentIndex = 0;
  Timer? _timer;

  ScenarioService() {
    _initializeData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeData() async {
    log("Data initialized");

    _initializeSetting();
    await _loadData();
    _isDataLoaded = true;

    notifyListeners();
  }

  Future<void> _loadData() async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final pathRef = storageRef.child(
          'economic_recovery_scenario/AAPL_economic_recovery_scenario.csv');

      final url = await pathRef.getDownloadURL();

      log(url);

      final response = await http.get(Uri.parse(url)); // http.get 사용
      if (response.statusCode == 200) {
        final csvString = response.body;
        // CSV Data
        List<List<dynamic>> csvStockData =
            const CsvToListConverter().convert(csvString, eol: '\n');

        _parseCSVToStockData(csvStockData);

        _startDataSimulation();

        notifyListeners();
      } else {
        throw Exception('Failed to load CSV file');
      }
    } catch (e) {
      log('Error loading data: $e');
    }
  }

  void _parseCSVToStockData(List<List<dynamic>> csvData) {
    // 첫 번째 행(헤더)을 제거합니다.
    csvData.removeAt(0);

    _stockDataList = csvData.map((row) {
      return StockData.fromList(row);
    }).toList();

    _calculateAxisValues();

    notifyListeners();
  }

  void _startDataSimulation() {
    _displayedStockDataList.add(_stockDataList[_currentIndex]);
    _currentIndex++;
    _calculateAxisValues();
    updateVisibleRange();
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentIndex < _stockDataList.length) {
        _displayedStockDataList.add(_stockDataList[_currentIndex]);
        _currentIndex++;
        _calculateAxisValues();
        updateVisibleRange();
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  // X축 업데이트
  void initializePrimaryXAxis() {
    if (_displayedStockDataList.isNotEmpty) {
      DateTime visibleMaximum = _displayedStockDataList.last.date;
      DateTime visibleMinimum =
          visibleMaximum.subtract(const Duration(days: 21));

      _primaryXAxis = DateTimeAxis(
        dateFormat: DateFormat.MMMd(),
        intervalType: DateTimeIntervalType.days,
        interval: 1,
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        initialVisibleMinimum: visibleMinimum,
        initialVisibleMaximum: visibleMaximum,
      );
    }
  }

  void _calculateAxisValues() {
    if (_displayedStockDataList.isEmpty) return;

    double minLow = _displayedStockDataList
        .map((data) => data.low)
        .reduce((a, b) => a < b ? a : b);
    double maxHigh = _displayedStockDataList
        .map((data) => data.high)
        .reduce((a, b) => a > b ? a : b);

    _yAxisMinimum = (minLow - (minLow * 0.1)).floorToDouble();
    _yAxisMaximum = (maxHigh + (maxHigh * 0.1)).ceilToDouble();
    _yAxisInterval = ((_yAxisMaximum - _yAxisMinimum) / 10).roundToDouble();
  }

  void updateVisibleRange() {
    if (_displayedStockDataList.isNotEmpty) {
      _visibleMaximum = _displayedStockDataList.last.date;
      _visibleMinimum = _visibleMaximum.subtract(const Duration(days: 21));

      _primaryXAxis = DateTimeAxis(
        dateFormat: DateFormat.MMMd(),
        intervalType: DateTimeIntervalType.days,
        interval: 1,
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        initialVisibleMinimum: _visibleMinimum,
        initialVisibleMaximum: _visibleMaximum,
        minimum: _stockDataList.first.date,
        maximum: _visibleMaximum,
      );

      notifyListeners();
    }
  }

  void _initializeSetting() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );

    _isLoadMoreView = false;
    _isNeedToUpdateView = false;
    _isDataUpdated = false;

    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
      enableSelectionZooming: true,
    );

    notifyListeners();
  }
}

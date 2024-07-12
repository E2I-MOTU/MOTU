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

  late double _yAxisMinimum;
  double get yAxisMinimum => _yAxisMinimum;

  late double _yAxisMaximum;
  double get yAxisMaximum => _yAxisMaximum;

  late double _yAxisInterval;
  double get yAxisInterval => _yAxisInterval;

  bool get isDataLoaded => _isDataLoaded;
  bool _isDataLoaded = false;

  ScenarioService() {
    _initializeData();
  }

  void _initializeData() {
    log("Data initialized");

    _initializeSetting();
    _loadData();

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

    _isDataLoaded = true;

    notifyListeners();
  }

  void _calculateAxisValues() {
    if (_stockDataList.isEmpty) return;

    double minLow =
        _stockDataList.map((data) => data.low).reduce((a, b) => a < b ? a : b);
    double maxHigh =
        _stockDataList.map((data) => data.high).reduce((a, b) => a > b ? a : b);

    _yAxisMinimum = (minLow - (minLow * 0.1)).floorToDouble();
    _yAxisMaximum = (maxHigh + (maxHigh * 0.1)).ceilToDouble();
    _yAxisInterval = ((_yAxisMaximum - _yAxisMinimum) / 10).roundToDouble();
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
    );

    notifyListeners();
  }
}

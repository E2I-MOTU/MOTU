import 'package:flutter/material.dart';
import 'package:motu/model/data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LiveChart extends StatelessWidget {
  const LiveChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candle Chart'),
      ),
      body: Center(
        child: SfCartesianChart(
          primaryXAxis: const DateTimeAxis(),
          series: <CandleSeries<StockData, DateTime>>[
            CandleSeries<StockData, DateTime>(
              dataSource: getStockData(),
              xValueMapper: (StockData data, _) => data.date,
              lowValueMapper: (StockData data, _) => data.low,
              highValueMapper: (StockData data, _) => data.high,
              openValueMapper: (StockData data, _) => data.open,
              closeValueMapper: (StockData data, _) => data.close,
            ),
          ],
        ),
      ),
    );
  }

  List<StockData> getStockData() {
    return [
      StockData(DateTime(2023, 1, 1), 100, 120, 90, 110, 110, 1000000),
      StockData(DateTime(2023, 1, 2), 110, 130, 105, 115, 115, 1200000),
      StockData(DateTime(2023, 1, 3), 115, 125, 110, 120, 120, 1300000),
      StockData(DateTime(2023, 1, 4), 120, 140, 115, 135, 135, 1400000),
      StockData(DateTime(2023, 1, 5), 135, 145, 130, 140, 140, 1500000),
      // 추가 데이터 포인트를 여기에 넣으세요
    ];
  }
}

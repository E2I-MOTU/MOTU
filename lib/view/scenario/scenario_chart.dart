import 'package:flutter/material.dart';
import 'package:motu/controller/scenario_service.dart';
import 'package:motu/model/stock_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ScenarioChart extends StatelessWidget {
  const ScenarioChart({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey<State>();

    return Scaffold(
      body: Consumer<ScenarioService>(builder: (context, service, child) {
        if (!service.isDataLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        return SfCartesianChart(
          key: globalKey,
          title: const ChartTitle(text: 'AAPL - 2016'),
          legend:
              const Legend(isVisible: true, position: LegendPosition.bottom),
          trackballBehavior: service.trackballBehavior,
          zoomPanBehavior: service.zoomPanBehavior,
          series: <CandleSeries<StockData, DateTime>>[
            CandleSeries<StockData, DateTime>(
              dataSource: service.stockDataList,
              xValueMapper: (StockData data, _) => data.date,
              lowValueMapper: (StockData data, _) => data.low,
              highValueMapper: (StockData data, _) => data.high,
              openValueMapper: (StockData data, _) => data.open,
              closeValueMapper: (StockData data, _) => data.close,

              // onRendererCreated: (controller) {},
            ),
          ],
          enableAxisAnimation: true,
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat.yMMM(),
            autoScrollingDelta: 8,
            autoScrollingDeltaType: DateTimeIntervalType.months,
            majorGridLines: const MajorGridLines(width: 0),
            enableAutoIntervalOnZooming: true,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryYAxis: NumericAxis(
            minimum: service.yAxisMinimum,
            maximum: service.yAxisMaximum,
            interval: service.yAxisInterval,
            numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
            opposedPosition: true,
          ),
        );
      }),
    );
  }
}

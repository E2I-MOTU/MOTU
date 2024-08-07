import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motu/model/stock_data.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class StockOrderTab extends StatelessWidget {
  const StockOrderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScenarioService>(builder: (context, service, child) {
      if (!service.isDataLoaded) {
        return const Center(child: CircularProgressIndicator());
      }

      return PageView(
        scrollDirection: Axis.vertical,
        children: [
          _buildFirstSection(context, service),
          _buildSecondSection(context, service)
        ],
      );
    });
  }
}

Widget _buildFirstSection(BuildContext context, ScenarioService service) {
  GlobalKey globalKey = GlobalKey<State>();
  Size screenSize = MediaQuery.of(context).size;

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          width: screenSize.width / 2,
          height: screenSize.height / 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(child: Text("15:00:00")),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 5,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PopupMenuButton<String>(
                      initialValue: service.selectedStock,
                      onSelected: (String value) {
                        service.setSelectedStock(value);
                      },
                      itemBuilder: (BuildContext context) {
                        return service.stockOptions.map((String option) {
                          return PopupMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(service.selectedStock,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    const Text(
                      "4,545원",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.35,
                child: SfCartesianChart(
                  key: globalKey,
                  // legend: const Legend(
                  //     isVisible: true, position: LegendPosition.bottom),
                  trackballBehavior: service.trackballBehavior,
                  zoomPanBehavior: service.zoomPanBehavior,
                  series: <CandleSeries<StockData, DateTime>>[
                    CandleSeries<StockData, DateTime>(
                      dataSource: service.displayedStockDataList,
                      xValueMapper: (StockData data, _) => data.date,
                      lowValueMapper: (StockData data, _) => data.low,
                      highValueMapper: (StockData data, _) => data.high,
                      openValueMapper: (StockData data, _) => data.open,
                      closeValueMapper: (StockData data, _) => data.close,
                      enableSolidCandles: true,
                      animationDuration: 500,
                    ),
                  ],
                  enableAxisAnimation: true,
                  primaryXAxis: service.primaryXAxis,
                  primaryYAxis: NumericAxis(
                    minimum: service.yAxisMinimum,
                    maximum: service.yAxisMaximum,
                    interval: service.yAxisInterval,
                    numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
                    opposedPosition: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("매도"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("매수"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(CupertinoIcons.chevron_compact_down),
      ),
    ],
  );
}

Widget _buildSecondSection(BuildContext context, ScenarioService service) {
  return SafeArea(
    child: Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.chevron_compact_up),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "종목 정보",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildInfoCard("시가총액", "1,000억원"),
              _buildInfoCard("배당수익률", "2.5%"),
              _buildInfoCard("PBR", "1.2"),
              _buildInfoCard("PER", "15.3"),
              _buildInfoCard("ROE", "12.5%"),
              _buildInfoCard("PSR", "1.8"),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildFinancialTable(),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoCard(String title, String value) {
  return Card(
    elevation: 5.0,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget _buildFinancialTable() {
  return Table(
    columnWidths: const <int, TableColumnWidth>{
      0: FlexColumnWidth(2),
      1: FlexColumnWidth(1),
      2: FlexColumnWidth(1),
      3: FlexColumnWidth(1),
      4: FlexColumnWidth(1),
    },
    children: [
      _buildTableRow(["항목", "2020", "2021", "2022", "2023"], isHeader: true),
      _buildTableRow(["매출액", "120억", "150억", "180억", "200억"]),
      _buildTableRow(["영업이익", "15억", "20억", "25억", "30억"]),
      _buildTableRow(["당기순이익", "12억", "16억", "20억", "24억"]),
      _buildTableRow(["자산총계", "550억", "600억", "650억", "700억"]),
      _buildTableRow(["부채총계", "220억", "240억", "260억", "280억"]),
    ],
  );
}

TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
  return TableRow(
    children: cells
        .map((cell) => TableCell(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  cell,
                  style: TextStyle(
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ))
        .toList(),
  );
}

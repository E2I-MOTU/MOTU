import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:motu/model/scenario/stock_data.dart';
import 'package:motu/util/util.dart';
import 'package:motu/view/scenario/widget/order/keyword_popup.dart';
import 'package:motu/view/scenario/widget/order/stock_trade_widget.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:motu/widget/motu_button.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../service/scenario_service.dart';

class StockOrderTab extends StatelessWidget {
  const StockOrderTab({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey<State>();
    Size screenSize = MediaQuery.of(context).size;

    return Consumer<ScenarioService>(builder: (context, service, child) {
      if (service.visibleStockData.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("차트를 불러오고 있습니다..."),
            ],
          ),
        );
      }

      int minutes = service.remainingTime.inMinutes;
      int seconds = (service.remainingTime.inSeconds % 60);

      return Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      width: screenSize.width / 2,
                      height: screenSize.height / 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.asset(
                                'assets/images/scenario/info_time.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${service.currentStockTime.year}년 ${service.currentStockTime.month}월 ${service.currentStockTime.day}일",
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                            const Opacity(
                              opacity: 0,
                              child: Icon(Icons.abc),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PopupMenuButton<String>(
                                  initialValue: service.selectedStock,
                                  onSelected: (String value) {
                                    service.setSelectedStock(value);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return service.stockOptions
                                        .map((String option) {
                                      return PopupMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 18,
                                        right: 10,
                                        top: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF4F4F4),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 1,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(service.selectedStock,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold)),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "${Formatter.format(service.visibleStockData.last.close.toInt())}원",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.45,
                            child: service.isChangeStock
                                ? const Center(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: 16),
                                      Text("관련주 불러오는 중.."),
                                    ],
                                  ))
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: SfCartesianChart(
                                      key: globalKey,
                                      // 주요 X축, Y축 설정
                                      primaryXAxis: DateTimeCategoryAxis(
                                        dateFormat: DateFormat.Md('ko_KR'),
                                        intervalType: DateTimeIntervalType.days,
                                        majorGridLines:
                                            const MajorGridLines(width: 0),
                                        edgeLabelPlacement:
                                            EdgeLabelPlacement.shift,
                                        initialVisibleMinimum: service
                                            .visibleStockData.last.x
                                            .subtract(const Duration(days: 20)),
                                        minimum:
                                            service.visibleStockData.first.x,
                                        maximum:
                                            service.visibleStockData.last.x,
                                      ),
                                      primaryYAxis: NumericAxis(
                                        minimum: service.yMinimum,
                                        maximum: service.yMaximum,
                                        interval: service.yInterval,
                                        numberFormat: NumberFormat.currency(
                                          locale: 'ko_KR',
                                          symbol: '₩',
                                          decimalDigits: 0,
                                        ),
                                        opposedPosition: true,
                                      ),
                                      // 축 범위 설정
                                      // axes: <ChartAxis>[
                                      //   NumericAxis(
                                      //     name: 'Volume',
                                      //     isVisible: false,
                                      //     interval: 1000000000,
                                      //     numberFormat: NumberFormat.compact(),
                                      //   ),
                                      // ],
                                      // series 데이터 설정
                                      series: <CartesianSeries<StockData,
                                          DateTime>>[
                                        CandleSeries<StockData, DateTime>(
                                          dataSource: service.visibleStockData,
                                          xValueMapper: (StockData data, _) =>
                                              data.x,
                                          openValueMapper:
                                              (StockData data, _) => data.open,
                                          closeValueMapper:
                                              (StockData data, _) => data.close,
                                          lowValueMapper: (StockData data, _) =>
                                              data.low,
                                          highValueMapper:
                                              (StockData data, _) => data.high,
                                          enableSolidCandles: true,
                                          emptyPointSettings:
                                              const EmptyPointSettings(
                                            mode: EmptyPointMode.gap,
                                          ),
                                          bearColor: Colors.blue,
                                          bullColor: Colors.red,
                                          animationDelay: 0,
                                          animationDuration: 500,
                                        ),
                                      ],
                                      // 십자선 설정
                                      crosshairBehavior: CrosshairBehavior(
                                        enable: true,
                                        activationMode:
                                            ActivationMode.longPress,
                                        lineType: CrosshairLineType.both,
                                        lineColor: Colors.grey,
                                        lineWidth: 1,
                                        lineDashArray: <double>[5, 5],
                                      ),
                                      // 트랙볼 설정
                                      trackballBehavior:
                                          CustomTrackballBehavior(),
                                      // 줌 팬 설정
                                      zoomPanBehavior: ZoomPanBehavior(
                                        enablePinching: true,
                                        enablePanning: true,
                                        zoomMode: ZoomMode.x,
                                      ),
                                      onActualRangeChanged:
                                          (ActualRangeChangedArgs args) {
                                        SchedulerBinding.instance
                                            .addPostFrameCallback((_) {
                                          service.setActualArgs(args);
                                          service.updateYAxisRange(args);
                                        });
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.1),
                  SizedBox(
                    height: screenSize.height,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: screenSize.height > 700 ? 16.0 : 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${service.selectedStock} 정보",
                                style: TextStyle(
                                  fontSize: screenSize.height > 700 ? 20 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${DateFormat('yyyy년 MM월 dd일').format(service.currentStockTime)} 기준",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenSize.height > 700 ? 12 : 10,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 1.2,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildInfoCard(
                                context,
                                title: "시가총액",
                                value: convertToKoreanNumber(
                                    service.currentStockInfo.marketCap.toInt()),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: KeywordPopupWidget(
                                          title:
                                              "시가총액이란?\n(Market Capitalization)",
                                          content:
                                              "시가총액은 주식시장에서 상장된 회사의 시장가치를 의미합니다. \n시가총액이 높을수록 회사의 규모가 크다고 볼 수 있습니다.",
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              _buildInfoCard(
                                context,
                                title: "배당수익률",
                                value:
                                    "${service.currentStockInfo.dividendYield}%",
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: KeywordPopupWidget(
                                          title: "배당수익률이란?\n(Dividend Yield)",
                                          content:
                                              "배당수익률은 주당 배당금을 주가로 나눈 값입니다. \n배당수익률이 높을수록 투자자에게 높은 수익을 제공합니다.",
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              _buildInfoCard(
                                context,
                                title: "PBR",
                                value: "${service.currentStockInfo.pbr}배",
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: KeywordPopupWidget(
                                          title:
                                              "PBR이란?\n(Price to Book Value Ratio)",
                                          content:
                                              "PBR은 주가를 주당순자산가치로 나눈 값입니다. \nPBR이 낮을수록 주식이 저평가되었다고 볼 수 있습니다.",
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              _buildInfoCard(
                                context,
                                title: "PER",
                                value: "${service.currentStockInfo.per}배",
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: KeywordPopupWidget(
                                          title:
                                              "PER이란?\n(Price to Earnings Ratio)",
                                          content:
                                              "PER은 주가를 주당순이익으로 나눈 값입니다. \nPER이 낮을수록 주식이 저평가되었다고 볼 수 있습니다.",
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              _buildInfoCard(
                                context,
                                title: "EPS",
                                value:
                                    "${Formatter.format(service.currentStockInfo.eps.toInt())}원",
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: KeywordPopupWidget(
                                          title: "EPS란?\n(Earnings Per Share)",
                                          content:
                                              "EPS는 주당순이익을 의미합니다. \nEPS가 높을수록 회사의 수익성이 좋다고 볼 수 있습니다.",
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              _buildInfoCard(
                                context,
                                title: "BPS",
                                value:
                                    "${Formatter.format(service.currentStockInfo.bps.toInt())}원",
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: KeywordPopupWidget(
                                          title:
                                              "BPS란?\n(Book Value Per Share)",
                                          content:
                                              "BPS는 주당 순자산가치를 의미합니다. 회사의 순자산을 발행주식수로 나눈 값입니다. \nBPS가 높을수록 회사의 가치가 높다고 볼 수 있습니다.",
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: _buildFinancialTable(context, service),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: ColorTheme.Grey2, width: 0.5),
                  bottom: BorderSide(color: ColorTheme.Grey2, width: 0.5),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: MotuNormalButton(
                      context,
                      text: '매수',
                      color: Colors.red,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              backgroundColor: Colors.white,
                              content: StockTradeWidget(
                                  tradeType: StockTradeType.buy),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: MotuNormalButton(
                      context,
                      text: '매도',
                      color: Colors.blue,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              backgroundColor: Colors.white,
                              content: StockTradeWidget(
                                  tradeType: StockTradeType.sell),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      // return PageView(
      //   scrollDirection: Axis.vertical,
      //   children: const [
      //     // const FirstChartSection(),
      //     FirstPageView(),
      //     SecondPageView(),
      //   ],
      // );
    });
  }

  // Trackball Widget
  TrackballBehavior CustomTrackballBehavior() {
    return TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.longPress,
      builder: (context, trackballDetails) {
        String date = formatDate(trackballDetails.point?.x);
        String? open = trackballDetails.point?.open?.toInt().toString();
        String? close = trackballDetails.point?.close?.toInt().toString();
        String? high = trackballDetails.point?.high?.toInt().toString();
        String? low = trackballDetails.point?.low?.toInt().toString();

        if (trackballDetails.seriesIndex == 0) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '시작 \t\t\t\t\t$open원',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '마지막\t\t\t$close원',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '최고 \t\t\t\t\t$high원',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '최저 \t\t\t\t\t$low원',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  String formatDate(dynamic value) {
    if (value is String) {
      try {
        // 입력된 문자열을 DateTime 객체로 파싱
        DateTime dateTime = DateTime.parse(value);

        // 원하는 형식으로 포맷팅
        final DateFormat formatter = DateFormat('yyyy.MM.dd', 'ko_KR');
        return formatter.format(dateTime);
      } catch (e) {
        print('날짜 파싱 오류: $e');
        return value; // 파싱에 실패한 경우 원본 값 반환
      }
    } else if (value is DateTime) {
      // 이미 DateTime 객체인 경우 바로 포맷팅
      final DateFormat formatter = DateFormat('yyyy.MM.dd', 'ko_KR');
      return formatter.format(value);
    }
    return value.toString(); // 다른 타입의 경우 문자열로 변환
  }

  Widget _buildInfoCard(
    context, {
    required String title,
    required String value,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: const Color(0xffF4F4F4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Image.asset(
                'assets/images/scenario/info_icon.png',
                width: 10,
                height: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialTable(BuildContext context, ScenarioService service) {
    final List<String> years = [
      "",
      "${service.q01Financial.year.toString().substring(2)}년 Q1",
      "${service.q02Financial.year.toString().substring(2)}년 Q2",
      "${service.q03Financial.year.toString().substring(2)}년 Q3",
      "${service.q04Financial.year.toString().substring(2)}년 Q4",
    ];
    final List<String> items = ["매출액", "영업이익", "당기순이익", "자산총계", "부채총계"];

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(1.25),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      children: [
        _buildTableRow(context, service, years, isHeader: true),
        ...items.asMap().entries.map((entry) {
          int index = entry.key;
          String item = entry.value;
          return _buildTableRow(
              context,
              service,
              [
                item,
                _getItemData(service, item, 0),
                _getItemData(service, item, 1),
                _getItemData(service, item, 2),
                _getItemData(service, item, 3),
              ],
              isItemRow: true,
              itemIndex: index);
        }),
      ],
    );
  }

  TableRow _buildTableRow(
      BuildContext context, ScenarioService service, List<String> cells,
      {bool isHeader = false, bool isItemRow = false, int itemIndex = -1}) {
    double height = MediaQuery.of(context).size.height;
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? const Color(0xffF4F4F4) : null,
        borderRadius: BorderRadius.circular(20.0),
      ),
      children: cells.asMap().entries.map((entry) {
        int index = entry.key;
        String cell = entry.value;
        bool isItemCell = isItemRow && index == 0;

        return TableCell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: height > 700 ? 10.0 : 6.0),
            alignment: Alignment.center,
            child: isItemCell
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            content: KeywordPopupWidget(
                              title: "$cell이란?",
                              content: service.explainTextbyCell(cell),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF4F4F4),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3.5,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 2),
                          Text(
                            cell,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Image.asset(
                            'assets/images/scenario/info_icon.png',
                            width: 10,
                            height: 10,
                          ),
                          const SizedBox(width: 2),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: isHeader
                        ? EdgeInsets.zero
                        : const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      cell,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight:
                            isHeader ? FontWeight.bold : FontWeight.normal,
                        fontSize: height > 700
                            ? isHeader
                                ? 15
                                : 13
                            : isHeader
                                ? 13
                                : 11,
                      ),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }

  // 1분기: 1-3월, 2분기: 4-6월, 3분기: 7-9월, 4분기: 10-12월
  String _getItemData(ScenarioService service, String item, int yearIndex) {
    final Map<String, List<String>> data = {
      "매출액": [
        service.q01Financial.revenue != -1
            ? "${Formatter.format(service.q01Financial.revenue.toInt())}억"
            : "???",
        service.q02Financial.revenue != -1
            ? "${Formatter.format(service.q02Financial.revenue.toInt())}억"
            : "???",
        service.q03Financial.revenue != -1
            ? "${Formatter.format(service.q03Financial.revenue.toInt())}억"
            : "???",
        service.q04Financial.revenue != -1
            ? "${Formatter.format(service.q04Financial.revenue.toInt())}억"
            : "???",
      ],
      "영업이익": ["???", "???", "???", "???"],
      "당기순이익": [
        service.q01Financial.netIncome != -1
            ? "${Formatter.format(service.q01Financial.netIncome.toInt())}억"
            : "???",
        service.q02Financial.netIncome != -1
            ? "${Formatter.format(service.q02Financial.netIncome.toInt())}억"
            : "???",
        service.q03Financial.netIncome != -1
            ? "${Formatter.format(service.q03Financial.netIncome.toInt())}억"
            : "???",
        service.q04Financial.netIncome != -1
            ? "${Formatter.format(service.q04Financial.netIncome.toInt())}억"
            : "???",
      ],
      "자산총계": [
        service.q01Financial.totalAssets != -1
            ? "${Formatter.format(service.q01Financial.totalAssets.toInt())}억"
            : "???",
        service.q02Financial.totalAssets != -1
            ? "${Formatter.format(service.q02Financial.totalAssets.toInt())}억"
            : "???",
        service.q03Financial.totalAssets != -1
            ? "${Formatter.format(service.q03Financial.totalAssets.toInt())}억"
            : "???",
        service.q04Financial.totalAssets != -1
            ? "${Formatter.format(service.q04Financial.totalAssets.toInt())}억"
            : "???",
      ],
      "부채총계": [
        service.q01Financial.totalLiabilities != -1
            ? "${Formatter.format(service.q01Financial.totalLiabilities.toInt())}억"
            : "???",
        service.q02Financial.totalLiabilities != -1
            ? "${Formatter.format(service.q02Financial.totalLiabilities.toInt())}억"
            : "???",
        service.q03Financial.totalLiabilities != -1
            ? "${Formatter.format(service.q03Financial.totalLiabilities.toInt())}억"
            : "???",
        service.q04Financial.totalLiabilities != -1
            ? "${Formatter.format(service.q04Financial.totalLiabilities.toInt())}억"
            : "???",
      ],
    };
    return data[item]![yearIndex];
  }
}

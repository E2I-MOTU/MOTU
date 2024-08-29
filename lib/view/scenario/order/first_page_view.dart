import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/view/scenario/widget/order/stock_trade_widget.dart';
import 'package:motu/widget/motu_button.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../../model/stock_data.dart';
import '../../../util/util.dart';

class FirstPageView extends StatelessWidget {
  const FirstPageView({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey<State>();
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Consumer<ScenarioService>(builder: (context, service, child) {
        int minutes = service.remainingTime.inMinutes;
        int seconds = (service.remainingTime.inSeconds % 60);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: screenSize.width / 2,
                height: screenSize.height / 18,
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
                      service.status == NoticeStatus.timer
                          ? Column(
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
                            )
                          : const Text(
                              "새로운 뉴스가 업데이트 되었어요! \n뉴스를 확인해보세요!",
                              style: TextStyle(fontSize: 10),
                            ),
                      service.status == NoticeStatus.timer
                          ? const Opacity(
                              opacity: 0,
                              child: Icon(Icons.abc),
                            )
                          : const SizedBox(),
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
                  borderRadius: BorderRadius.circular(30),
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
                              return service.stockOptions.map((String option) {
                                return PopupMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList();
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 18, right: 10, top: 10, bottom: 10),
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
                                          color: Theme.of(context).primaryColor,
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
                      height: screenSize.height * 0.43,
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
                          : SfCartesianChart(
                              key: globalKey,
                              // 주요 X축, Y축 설정
                              primaryXAxis: DateTimeAxis(
                                dateFormat: DateFormat.Md("ko_KR"),
                                intervalType: DateTimeIntervalType.days,
                                interval: 1,
                                majorGridLines: const MajorGridLines(width: 0),
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                initialVisibleMinimum: service
                                    .visibleStockData.last.x
                                    .subtract(const Duration(days: 20)),
                                // initialVisibleMaximum:
                                //     service.visibleStockData.last.x,
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
                              axes: <ChartAxis>[
                                NumericAxis(
                                  name: 'Volume',
                                  isVisible: false,
                                  interval: 1000000000,
                                  numberFormat: NumberFormat.compact(),
                                ),
                              ],
                              // series 데이터 설정
                              series: <CartesianSeries<StockData, DateTime>>[
                                CandleSeries<StockData, DateTime>(
                                  dataSource: service.visibleStockData,
                                  xValueMapper: (StockData data, _) => data.x,
                                  openValueMapper: (StockData data, _) =>
                                      data.open,
                                  closeValueMapper: (StockData data, _) =>
                                      data.close,
                                  lowValueMapper: (StockData data, _) =>
                                      data.low,
                                  highValueMapper: (StockData data, _) =>
                                      data.high,
                                  enableSolidCandles: true,
                                  bullColor: Colors.blue,
                                  animationDelay: 0,
                                  animationDuration: 500,
                                ),
                                // ColumnSeries<StockData, DateTime>(
                                //   dataSource: service.visibleStockData,
                                //   yAxisName: 'Volume',
                                //   xValueMapper: (StockData data, _) => data.x,
                                //   yValueMapper: (StockData data, _) => data.volume,
                                //   animationDelay: 0,
                                //   animationDuration: 500,
                                //   opacity: 0.8,
                                // ),
                              ],
                              // 십자선 설정
                              crosshairBehavior: CrosshairBehavior(
                                enable: true,
                                activationMode: ActivationMode.longPress,
                                lineType: CrosshairLineType.both,
                                lineColor: Colors.grey,
                                lineWidth: 1,
                                lineDashArray: <double>[5, 5],
                              ),
                              // 트랙볼 설정
                              trackballBehavior: CustomTrackballBehavior(),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 24.0),
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
                          const SizedBox(width: 24),
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
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
              ),
            )
          ],
        );
      }),
    );
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
}

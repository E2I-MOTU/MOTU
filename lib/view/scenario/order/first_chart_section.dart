// import 'package:flutter/material.dart';
// import 'package:interactive_chart/interactive_chart.dart';
// import 'package:motu/provider/scenario_service.dart';
// import 'package:provider/provider.dart';

// import 'mock_data.dart';

// class FirstChartSection extends StatefulWidget {
//   const FirstChartSection({super.key});

//   @override
//   State<FirstChartSection> createState() => _FirstChartSectionState();
// }

// class _FirstChartSectionState extends State<FirstChartSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ScenarioService>(
//       builder: (context, service, child) {
//         return Scaffold(
//           appBar: AppBar(
//             leading: const SizedBox(),
//             actions: [
//               IconButton(
//                 icon: Icon(
//                   service.showAverage
//                       ? Icons.show_chart
//                       : Icons.bar_chart_outlined,
//                 ),
//                 onPressed: () {
//                   service.toggleTrendLines();
//                 },
//               ),
//             ],
//           ),
//           body: SafeArea(
//             minimum: const EdgeInsets.all(24.0),
//             child: InteractiveChart(
//               /** Only [candles] is required */
//               candles: service.visibleData,
//               /** Uncomment the following for examples on optional parameters */
//               initialVisibleCandleCount: 40,
//               /** Example styling */
//               style: ChartStyle(
//                 priceGainColor: Colors.red,
//                 priceLossColor: Colors.blue,
//                 volumeColor: Colors.grey,
//                 trendLineStyles: [
//                   Paint()
//                     ..strokeWidth = 1.0
//                     ..strokeCap = StrokeCap.round
//                     ..color = Colors.green,
//                   Paint()
//                     ..strokeWidth = 2.0
//                     ..strokeCap = StrokeCap.round
//                     ..color = Colors.orange,
//                   Paint()
//                     ..strokeWidth = 3.0
//                     ..strokeCap = StrokeCap.round
//                     ..color = Colors.yellow,
//                 ],
//                 priceGridLineColor: Colors.grey,
//                 priceLabelStyle: const TextStyle(color: Colors.grey),
//                 timeLabelStyle: const TextStyle(color: Colors.grey),
//                 selectionHighlightColor: Colors.grey.withOpacity(0.5),
//                 overlayBackgroundColor: Colors.black,
//                 overlayTextStyle: const TextStyle(color: Colors.white),
//                 timeLabelHeight: 24,
//                 priceLabelWidth: 36,
//                 volumeHeightFactor: 0.2, // volume area is 20% of total height
//               ),
//               /** Customize axis labels */
//               // timeLabel: (timestamp, visibleDataCount) => "📅",
//               priceLabel: (price) => "\$${price.toStringAsFixed(2)}",
//               /** Customize overlay (tap and hold to see it)
//                  * Or return an empty object to disable overlay info. */
//               overlayInfo: (candle) => {
//                 "날짜": formatTimestamp(candle.timestamp),
//                 "시작": "${candle.open?.toStringAsFixed(2)}",
//                 "마지막": "${candle.close?.toStringAsFixed(2)}",
//                 "최고": "${candle.high?.toStringAsFixed(2)}",
//                 "최저": "${candle.low?.toStringAsFixed(2)}",
//               },
//               /** Callbacks */
//               onTap: (candle) => print("user tapped on $candle"),
//               onCandleResize: (width) => print("each candle is $width wide"),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String formatTimestamp(int timestamp) {
//     // timestamp를 DateTime 객체로 변환
//     DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

//     // 요일을 한국어로 변환
//     List<String> daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
//     String dayOfWeek = daysOfWeek[dateTime.weekday - 1];

//     // 원하는 형식으로 변환
//     String formattedDate =
//         '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')} ($dayOfWeek)';

//     return formattedDate;
//   }
// }

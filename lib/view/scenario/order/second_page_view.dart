import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motu/provider/scenario_service.dart';
import 'package:motu/util/util.dart';
import 'package:motu/view/scenario/widget/order/keyword_popup.dart';
import 'package:provider/provider.dart';

class SecondPageView extends StatelessWidget {
  const SecondPageView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Consumer<ScenarioService>(builder: (context, service, child) {
      return SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: height > 700 ? 16.0 : 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${service.selectedStock} 정보",
                    style: TextStyle(
                      fontSize: height > 700 ? 20 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${DateFormat('yyyy년 MM월 dd일').format(service.currentStockTime)} 기준",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height > 700 ? 12 : 10,
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                              title: "시가총액이란?\n(Market Capitalization)",
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
                    value: "${service.currentStockInfo.dividendYield}%",
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
                              title: "PBR이란?\n(Price to Book Value Ratio)",
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
                              title: "PER이란?\n(Price to Earnings Ratio)",
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
                              title: "BPS란?\n(Book Value Per Share)",
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
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: _buildFinancialTable(context, service),
              ),
            ),
          ],
        ),
      );
    });
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

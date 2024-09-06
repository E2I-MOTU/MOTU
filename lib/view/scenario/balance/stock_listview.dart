import 'package:flutter/material.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/util/util.dart';
import 'package:provider/provider.dart';

class StockListView extends StatelessWidget {
  const StockListView({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Consumer<ScenarioService>(builder: (context, service, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                '보유 주식',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            service.checkInvested()
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '관련주',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${service.currentPercentStr()}\n${service.currentPriceStr()}',
                          style: TextStyle(
                            fontSize: 15,
                            color:
                                service.unrealizedPnL + service.realizedPnL == 0
                                    ? Colors.black
                                    : service.unrealizedPnL +
                                                service.realizedPnL >
                                            0
                                        ? Colors.red
                                        : Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: screenSize.height * 0.07,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "투자한 종목이 없습니다.",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 16),
            Column(
              children: service.investStocks.keys.map<Widget>((stock) {
                if (service.investStocks[stock]![0] != 0) {
                  switch (stock) {
                    case '관련주 A':
                      return StockItem(
                        logo: "assets/images/scenario/stock_a.png",
                        name: stock,
                        amount: service.investStocks[stock]![0],
                        value: Formatter.format(
                            service.investStocks[stock]![0] *
                                service.visibleAllStockData[stock]!.last.close
                                    .toInt()),
                      );
                    case '관련주 B':
                      return StockItem(
                        logo: "assets/images/scenario/stock_b.png",
                        name: stock,
                        amount: service.investStocks[stock]![0],
                        value: Formatter.format(
                            service.investStocks[stock]![0] *
                                service.visibleAllStockData[stock]!.last.close
                                    .toInt()),
                      );
                    case '관련주 C':
                      return StockItem(
                        logo: "assets/images/scenario/stock_c.png",
                        name: stock,
                        amount: service.investStocks[stock]![0],
                        value: Formatter.format(
                            service.investStocks[stock]![0] *
                                service.visibleAllStockData[stock]!.last.close
                                    .toInt()),
                      );
                    case '관련주 D':
                      return StockItem(
                        logo: "assets/images/scenario/stock_d.png",
                        name: stock,
                        amount: service.investStocks[stock]![0],
                        value: Formatter.format(
                            service.investStocks[stock]![0] *
                                service.visibleAllStockData[stock]!.last.close
                                    .toInt()),
                      );
                    case '관련주 E':
                      return StockItem(
                        logo: "assets/images/scenario/stock_e.png",
                        name: stock,
                        amount: service.investStocks[stock]![0],
                        value: Formatter.format(
                            service.investStocks[stock]![0] *
                                service.visibleAllStockData[stock]!.last.close
                                    .toInt()),
                      );
                    default:
                      return const SizedBox.shrink(); // 기본적으로 빈 위젯 반환
                  }
                }
                return const SizedBox.shrink(); // 주식 값이 0인 경우 빈 위젯 반환
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget StockItem(
      {required String logo,
      required String name,
      required int amount,
      required String value}) {
    return ListTile(
      leading: Image.asset(
        logo,
        fit: BoxFit.contain,
        width: 40,
      ),
      title: Text(name),
      subtitle: Text('$amount주'),
      trailing: Text(value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

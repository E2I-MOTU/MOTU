import 'package:flutter/material.dart';
import 'package:motu/model/balance_detail.dart';
import 'package:motu/model/scenario_result.dart';
import 'package:motu/service/auth_service.dart';
import 'package:motu/view/scenario/balance/stock_balance.dart';
import 'package:motu/view/scenario/news/stock_news_tab.dart';
import 'package:motu/view/scenario/order/stock_order.dart';
import 'package:motu/view/scenario/timeover_page.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:motu/widget/common_dialog.dart';
import 'package:provider/provider.dart';

import '../../service/scenario_service.dart';

class ScenarioPage extends StatelessWidget {
  const ScenarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final provider = Provider.of<ScenarioService>(context);

    provider.onNavigate = () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TimeoverPage()),
        (route) => false,
      );
    };

    provider.updateUserBalanceWhenFinish = () {
      final authService = Provider.of<AuthService>(context, listen: false);
      final scenarioService =
          Provider.of<ScenarioService>(context, listen: false);

      int remainingStockPrice = scenarioService.getRemainStockToBalance();
      authService.user.balance += remainingStockPrice;

      int change = authService.user.balance - scenarioService.originBalance;
      bool isIncome = change > 0;
      int amount = change.abs();

      BalanceDetail thisDetail = BalanceDetail(
        date: DateTime.now(),
        content: "시나리오로 인한 잔고 변동",
        amount: amount,
        isIncome: isIncome,
      );
      authService.addBalanceDetail(thisDetail);

      ScenarioResult result = ScenarioResult(
        date: DateTime.now(),
        subject: scenarioService.getScenarioTitle(
            scenarioService.selectedScenario ?? ScenarioType.covid),
        isIncome: isIncome,
        totalReturn: amount,
        returnRate: scenarioService.totalPurchasePrice == 0
            ? "0.0"
            : ((scenarioService.totalRatingPrice -
                        scenarioService.totalPurchasePrice) /
                    scenarioService.totalPurchasePrice *
                    100)
                .toStringAsFixed(1),
      );
      authService.addScenarioRecord(result);
    };

    return Consumer<ScenarioService>(builder: (context, service, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            service.getScenarioTitle(
                service.selectedScenario ?? ScenarioType.covid),
            style: const TextStyle(fontSize: 18),
          ),
          leading: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CommonDialog(context);
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(18), // 패딩 조절
              child: Image.asset(
                "assets/images/scenario/exit.png",
                fit: BoxFit.contain, // 이미지가 컨테이너에 맞게 조절됨
              ),
            ),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: TabBar(
                tabs: [
                  SizedBox(
                    width: size.width * 0.12,
                    child: const Tab(
                        child: Text("주문",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(
                    width: size.width * 0.12,
                    child: Tab(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("뉴스",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        service.checkUnreadNews() != 0
                            ? const SizedBox(width: 6)
                            : const SizedBox(),
                        // 동그란 원 안에 Text로 숫자를 표시할 수 있는 원을 만들어줘
                        service.checkUnreadNews() != 0
                            ? Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  service.checkUnreadNews().toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    )),
                  ),
                  SizedBox(
                    width: size.width * 0.12,
                    child: const Tab(
                        child: Text("현황",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ],
                indicatorColor: ColorTheme.Purple1,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.only(left: 10),
              ),
            ),
            body: const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                StockOrderTab(),
                StockNewsTab(),
                StockBalanceTab(),
              ],
            ),
          ),
        ),
      );
    });
  }
}

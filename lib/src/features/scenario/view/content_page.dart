import 'package:flutter/material.dart';
import 'package:motu/src/features/profile/model/balance_detail.dart';
import 'package:motu/src/features/scenario/model/scenario_result.dart';
import 'package:motu/src/features/login/service/auth_service.dart';
import 'package:motu/src/features/scenario/view/balance/stock_balance.dart';
import 'package:motu/src/features/scenario/view/news/stock_news_tab.dart';
import 'package:motu/src/features/scenario/view/order/stock_order.dart';
import 'package:motu/src/features/scenario/view/timeover_page.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:motu/src/common/view/widget/common_dialog.dart';
import 'package:provider/provider.dart';

import '../service/scenario_service.dart';

class ContentPage extends StatelessWidget {
  final ScenarioService service;

  const ContentPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    service.onNavigate = () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TimeoverPage()),
        (route) => false,
      );
    };

    service.updateUserBalanceWhenFinish = () {
      final authService = Provider.of<AuthService>(context, listen: false);

      int remainingStockPrice = service.getRemainStockToBalance();
      authService.user?.balance += remainingStockPrice;

      int change = authService.user!.balance - service.originBalance;
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
        subject: service
            .getScenarioTitle(service.selectedScenario ?? ScenarioType.disease),
        isIncome: isIncome,
        totalReturn: amount,
        returnRate: service.totalPurchasePrice == 0
            ? "0.0"
            : ((service.totalRatingPrice - service.totalPurchasePrice) /
                    service.totalPurchasePrice *
                    100)
                .toStringAsFixed(1),
      );
      authService.addScenarioRecord(result);
    };

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          title: Text(
            service.getScenarioTitle(
                service.selectedScenario ?? ScenarioType.disease),
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
              padding: const EdgeInsets.all(10), // 패딩 조절
              child: Image.asset(
                "assets/images/scenario/exit.png",
                fit: BoxFit.contain, // 이미지가 컨테이너에 맞게 조절됨
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: Column(
              children: [
                TabBar(
                  tabs: [
                    SizedBox(
                      width: size.width * 0.13,
                      child: const Tab(
                          child: Text("주문",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                    SizedBox(
                      width: size.width * 0.13,
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
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.13,
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
                const Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      StockOrderTab(),
                      StockNewsTab(),
                      StockBalanceTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

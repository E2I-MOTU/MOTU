import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motu/view/scenario/balance/stock_balance.dart';
import 'package:motu/view/scenario/news/stock_news.dart';
import 'package:motu/view/scenario/order/stock_order.dart';
import 'package:provider/provider.dart';

import '../../provider/scenario_service.dart';

class ScenarioPage extends StatelessWidget {
  const ScenarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<ScenarioService>(builder: (context, service, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("주제", style: TextStyle(fontSize: 18)),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(16), // 패딩 조절
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
                        service.unreadNewsCount != 0
                            ? const SizedBox(width: 7)
                            : const SizedBox(),
                        // 동그란 원 안에 Text로 숫자를 표시할 수 있는 원을 만들어줘
                        service.unreadNewsCount != 0
                            ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  service.unreadNewsCount.toString(),
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
                        child: Text("잔고",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ],
                indicatorColor: Theme.of(context).primaryColor,
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

import 'package:flutter/material.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/view/scenario/tabs/stock_balance.dart';
import 'package:motu/view/scenario/tabs/stock_news.dart';
import 'package:motu/view/scenario/tabs/stock_order.dart';
import 'package:provider/provider.dart';

class ScenarioPage extends StatelessWidget {
  const ScenarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScenarioService>(builder: (context, service, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("주제"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
        ),
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              flexibleSpace: const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: TabBar(
                  tabs: [
                    Tab(
                        child: Text("주문",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Tab(
                        child: Text("뉴스",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Tab(
                        child: Text("잔고",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: TabBarView(
              children: [
                const StockOrderTab(),
                const StockNewsTab(),
                StockBalanceTab(),
              ],
            ),
          ),
        ),
      );
    });
  }
}

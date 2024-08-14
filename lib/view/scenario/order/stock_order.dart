import 'package:flutter/material.dart';
import 'package:motu/view/scenario/order/first_page_view.dart';
import 'package:provider/provider.dart';
import '../../../provider/scenario_service.dart';
import 'second_page_view.dart';

class StockOrderTab extends StatelessWidget {
  const StockOrderTab({super.key});

  @override
  Widget build(BuildContext context) {
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

      return PageView(
        scrollDirection: Axis.vertical,
        children: const [
          // const FirstChartSection(),
          FirstPageView(),
          SecondPageView(),
        ],
      );
    });
  }
}

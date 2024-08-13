import 'package:flutter/material.dart';
import 'package:motu/widget/custom_divider.dart';
import 'package:motu/view/scenario/balance/investment_status_toggle.dart';
import 'package:motu/view/scenario/balance/sales_record.dart';
import 'package:motu/view/scenario/balance/stock_listview.dart';

class StockBalanceTab extends StatelessWidget {
  const StockBalanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InvestmentStatusToggle(),
          CustomDivider(),
          const StockListView(),
          CustomDivider(),
          const SalesRecord(),
          CustomDivider(),
        ],
      ),
    );
  }
}

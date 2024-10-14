import 'package:flutter/material.dart';
import 'package:motu/src/features/scenario/view/balance/my_status.dart';
import 'package:motu/src/common/view/widget/custom_divider.dart';
import 'package:motu/src/features/scenario/view/balance/investment_status_toggle.dart';
import 'package:motu/src/features/scenario/view/balance/sales_record.dart';
import 'package:motu/src/features/scenario/view/balance/stock_listview.dart';

class StockBalanceTab extends StatelessWidget {
  const StockBalanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyStatus(),
          const InvestmentStatusToggle(haveTitle: true),
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

import 'package:flutter/material.dart';
import 'package:motu/model/stock_news.dart';
import 'package:motu/view/scenario/widget/news/news_tile.dart';
import 'package:provider/provider.dart';

import '../../../provider/scenario_service.dart';

class StockNewsTab extends StatelessWidget {
  const StockNewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ScenarioService>(builder: (context, service, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: service.sortNewsList().isEmpty
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(child: Text('뉴스가 없습니다.')),
                  ],
                )
              : Column(
                  children: [
                    const Divider(),
                    for (StockNews news in service.sortNewsList())
                      Column(
                        children: [
                          NewsListTile(context, news),
                          const Divider(),
                        ],
                      ),
                  ],
                ),
        );
      }),
    );
  }
}
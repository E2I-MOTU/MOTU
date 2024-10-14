import 'package:flutter/material.dart';
import 'package:motu/src/features/scenario/model/stock_news.dart';
import 'package:motu/src/features/scenario/view/widget/news/news_tile.dart';
import 'package:provider/provider.dart';

import '../../service/scenario_service.dart';

class StockNewsTab extends StatelessWidget {
  const StockNewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ScenarioService>(builder: (context, service, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: service.sortNewsList().isEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          '현재 업데이트된 뉴스가 없습니다',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
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

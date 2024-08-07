import 'package:flutter/material.dart';
import 'package:motu/model/scenario_news.dart';
import 'package:motu/service/scenario_news_service.dart';
import 'package:motu/widget/scenario/news_tile.dart';
import 'package:provider/provider.dart';

class StockNewsTab extends StatelessWidget {
  const StockNewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ScenarioNewsService>(builder: (context, service, child) {
        final sortedNews = List<ScenarioNews>.from(service.news)
          ..sort((a, b) {
            if (a.isRead == b.isRead) return 0;
            return a.isRead ? 1 : -1;
          });

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              const Divider(),
              for (ScenarioNews news in sortedNews)
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

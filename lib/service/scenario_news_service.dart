import 'package:flutter/material.dart';
import 'package:motu/model/stock_news.dart';

class ScenarioNewsService with ChangeNotifier {
  final List<StockNews> _news = ScenarioNewsData;

  List<StockNews> get news => _news;
}

import 'package:flutter/material.dart';
import 'package:motu/model/scenario_news.dart';

class ScenarioNewsService with ChangeNotifier {
  final List<ScenarioNews> _news = ScenarioNewsData;

  List<ScenarioNews> get news => _news;
}

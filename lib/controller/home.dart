import 'package:flutter/material.dart';
import 'package:motu/view/scenario/scenario_list.dart';
import 'package:motu/view/my_page.dart';
import 'package:motu/view/home_page_contents.dart';

import '../view/quiz/quiz.dart';

class HomeController {
  static Widget getPage(int index) {
    switch (index) {
      case 0:
        return const HomePageContent();
      case 1:
        return QuizSelectionScreen();
      case 2:
        return const ScenarioList();
      case 3:
        return const MyPage();
      default:
        return const HomePageContent();
    }
  }
}

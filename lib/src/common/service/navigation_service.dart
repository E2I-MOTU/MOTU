import 'package:flutter/material.dart';
import 'package:motu/src/features/home/view/home_page.dart';
import 'package:motu/src/features/profile/view/profile_page.dart';
import 'package:motu/src/features/scenario/view/scenario_page.dart';
import '../../features/learning/view/learning_page.dart';

class NavigationService with ChangeNotifier {
  String? uid;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  final List<Widget> _screens = [
    const HomePage(),
    const LearningPage(),
    const ScenarioPage(),
    const ProfilePage(),
  ];

  List<Widget> get screens => _screens;

  void goToHome() => setSelectedIndex(0);
  void goToLearning() => setSelectedIndex(1);
  void goToScenario() => setSelectedIndex(2);
  void goToProfile() => setSelectedIndex(3);
}

import 'package:flutter/material.dart';
import 'package:motu/view/home/home_page.dart';
import 'package:motu/view/profile/profile_page.dart';
import 'package:motu/view/scenario/scenario_list.dart';
import '../view/learning/learning_contents.dart';

class NavigationService with ChangeNotifier {
  String? uid;

  void initialize(String uid) {
    this.uid = uid;
    _screens[1] = LearningContentscreen(uid: uid);
    notifyListeners();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  final List<Widget> _screens = [
    const HomePage(),
    Container(),
    const ScenarioList(),
    ProfilePage(),
  ];

  Widget get currentScreen => _screens[_selectedIndex];

  void goToHome() => setSelectedIndex(0);
  void goToLearning() => setSelectedIndex(1);
  void goToScenario() => setSelectedIndex(2);
  void goToProfile() => setSelectedIndex(3);
}

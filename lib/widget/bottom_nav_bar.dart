import 'package:flutter/material.dart';
import 'package:motu/provider/navigation_provider.dart';
import 'package:provider/provider.dart';
import '../view/theme/color_theme.dart';

Widget BottomNavBar() {
  return Consumer<NavigationService>(builder: (context, service, child) {
    return BottomNavigationBar(
      backgroundColor: ColorTheme.colorWhite,
      selectedItemColor: ColorTheme.colorPrimary,
      unselectedItemColor: ColorTheme.colorDisabled,
      currentIndex: service.selectedIndex,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        print(index);
        service.setSelectedIndex(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz),
          label: '학습하기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_graph),
          label: '시나리오',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '프로필',
        ),
      ],
    );
  });
}

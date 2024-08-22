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
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            service.selectedIndex == 0
                ? 'assets/images/icon/home_selected.png'
                : 'assets/images/icon/home_unselected.png',
            width: 24,
            height: 24,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            service.selectedIndex == 1
                ? 'assets/images/icon/learning_selected.png'
                : 'assets/images/icon/learning_unselected.png',
            width: 24,
            height: 24,
          ),
          label: '학습하기',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            service.selectedIndex == 2
                ? 'assets/images/icon/scenario_selected.png'
                : 'assets/images/icon/scenario_unselected.png',
            width: 24,
            height: 24,
          ),
          label: '시나리오',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            service.selectedIndex == 3
                ? 'assets/images/icon/mypage_selected.png'
                : 'assets/images/icon/mypage_unselected.png',
            width: 24,
            height: 24,
          ),
          label: '프로필',
        ),
      ],
    );
  });
}

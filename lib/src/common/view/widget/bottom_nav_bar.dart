import 'package:flutter/material.dart';
import 'package:motu/src/common/service/navigation_service.dart';
import 'package:provider/provider.dart';
import '../../../design/color_theme.dart';

Widget BottomNavBar() {
  return Consumer<NavigationService>(builder: (context, service, child) {
    return SizedBox(
      height: 50,
      child: BottomNavigationBar(
        backgroundColor: ColorTheme.colorWhite,
        selectedItemColor: ColorTheme.colorPrimary,
        unselectedItemColor: ColorTheme.colorDisabled,
        currentIndex: service.selectedIndex,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          service.setSelectedIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              service.selectedIndex == 0
                  ? 'assets/images/icon/home_selected.png'
                  : 'assets/images/icon/home_unselected.png',
              width: 20,
              height: 20,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              service.selectedIndex == 1
                  ? 'assets/images/icon/learning_selected.png'
                  : 'assets/images/icon/learning_unselected.png',
              width: 20,
              height: 20,
            ),
            label: '학습하기',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              service.selectedIndex == 2
                  ? 'assets/images/icon/scenario_selected.png'
                  : 'assets/images/icon/scenario_unselected.png',
              width: 20,
              height: 20,
            ),
            label: '실전학습',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              service.selectedIndex == 3
                  ? 'assets/images/icon/mypage_selected.png'
                  : 'assets/images/icon/mypage_unselected.png',
              width: 20,
              height: 20,
            ),
            label: '프로필',
          ),
        ],
      ),
    );
  });
}

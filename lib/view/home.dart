import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motu/controller/home.dart';
import 'package:motu/controller/bottom_navigation_bar.dart';
import 'components/drawer_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      drawer: const DrawerMenu(),
      body: Consumer<BottomNavigationBarProvider>(
        builder: (context, provider, child) {
          return HomeController.getPage(provider.currentIndex);
        },
      ),
      bottomNavigationBar: Consumer<BottomNavigationBarProvider>(
        builder: (context, provider, child) {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.pink,
            unselectedItemColor: Colors.grey,
            currentIndex: provider.currentIndex,
            onTap: (index) {
              provider.setIndex(index);
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
                label: '마이페이지',
              ),
            ],
          );
        },
      ),
    );
  }
}

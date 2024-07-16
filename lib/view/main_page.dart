import 'package:flutter/material.dart';
import 'package:motu/widget/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:motu/service/navigation_service.dart';
import '../widget/drawer_menu.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      body: Consumer<NavigationService>(
        builder: (context, service, child) {
          return service.currentScreen;
        },
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

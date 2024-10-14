import 'package:flutter/material.dart';
import 'package:motu/widget/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:motu/service/navigation_service.dart';

class NavPage extends StatelessWidget {
  const NavPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = context.watch<NavigationService>();
    return Scaffold(
      body: IndexedStack(
        index: navigationService.selectedIndex,
        children: navigationService.screens,
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

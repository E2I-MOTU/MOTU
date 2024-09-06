import 'package:flutter/material.dart';
import 'package:motu/widget/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:motu/provider/navigation_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NavigationService>(
        builder: (context, service, child) {
          return service.currentScreen;
        },
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

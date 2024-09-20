import 'package:flutter/material.dart';
import 'package:motu/service/auth_service.dart';
import 'package:motu/widget/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:motu/provider/navigation_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<AuthService>(context, listen: false).getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          }

          return Scaffold(
            body: Consumer<NavigationService>(
              builder: (context, service, child) {
                return service.currentScreen;
              },
            ),
            bottomNavigationBar: BottomNavBar(),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:motu/view/scenario/scenario_list.dart';
import '../view/login/logout.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Text(
              '메뉴',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('홈'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_graph),
            title: const Text('시나리오'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScenarioList()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('설정'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }
}

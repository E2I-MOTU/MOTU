import 'package:flutter/material.dart';
import 'package:motu/view/scenario/scenario_list.dart';
import '../view/login/logout.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.zero,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.asset(
                  'assets/images/motu_logo.png',
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('홈'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.auto_graph),
                    title: const Text('시나리오'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScenarioList()),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('설정'),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('로그아웃'),
                    onTap: () => logout(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:motu/service/auth_service.dart';
import 'package:motu/view/profile/widget/attendance_builder.dart';
import 'package:motu/view/profile/widget/menu_tile_builder.dart';
import 'package:motu/view/profile/widget/section_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../terminology/bookmark.dart';
import '../theme/color_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> learningStatusItems = [
      {
        'title': '수료 완료',
        'onTap': () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => CompletionPage(uid: userData!.uid)),
          // );
        }
      },
      {'title': '학습 진도', 'onTap': () {}},
      {
        'title': '용어 목록',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookmarkPage()),
          );
        }
      },
      {'title': '시나리오 기록', 'onTap': () {}},
    ];

    final List<Map<String, dynamic>> customerServiceItems = [
      {'title': 'FAQ', 'onTap': () {}},
      {'title': '공지사항', 'onTap': () {}},
      {'title': '문의하기', 'onTap': () {}},
    ];

    final NumberFormat currencyFormat = NumberFormat('#,##0');

    return Consumer<AuthService>(builder: (context, service, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('마이페이지'),
          backgroundColor: ColorTheme.White,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                service.signOut();
              },
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/person.png'),
                ),
                title: const Text("d",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: const Text("userData!.email"),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 16.0, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                onTap: () async {
                  // final updatedUserData = await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           ProfileDetailPage(userData: userData!)),
                  // );
                  // if (updatedUserData != null) {
                  //   _updateUserData(updatedUserData);
                  // }
                },
              ),
              const SizedBox(height: 16),
              const ListTile(
                title: Text(
                  '잔고 내역',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.monetization_on,
                            size: 16.0, color: ColorTheme.colorPrimary),
                        SizedBox(width: 8.0),
                        Text(
                          '보유 자산',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currencyFormat.format(33),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: ColorTheme.colorPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios,
                              size: 16.0, color: Colors.grey),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => BalanceDetailPage(
                            //           balance: 33)),
                            // );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const ListTile(
                title: Text(
                  '출석 현황',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              buildSectionCard(
                context,
                children: buildAttendanceWeek(context, []),
                backgroundColor: ColorTheme.colorNeutral,
              ),
              const SizedBox(height: 16),
              const ListTile(
                title: Text(
                  '학습 현황',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...learningStatusItems.map((item) {
                return buildMenuTile(
                  title: item['title'],
                  onTap: item['onTap'],
                );
              }),
              const SizedBox(height: 16),
              const ListTile(
                title: Text(
                  '고객센터',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...customerServiceItems.map((item) {
                return buildMenuTile(
                  title: item['title'],
                  onTap: item['onTap'],
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}

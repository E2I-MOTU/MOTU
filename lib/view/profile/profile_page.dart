import 'package:flutter/material.dart';
import 'package:motu/view/profile/widget/attendance_builder.dart';
import 'package:motu/view/profile/widget/menu_tile_builder.dart';
import 'package:motu/view/profile/widget/section_builder.dart';
import '../../model/user_data.dart';
import '../../service/profile_service.dart';
import '../terminology/bookmark.dart';
import '../theme/color_theme.dart';
import 'balance_detail_page.dart';
import 'completion_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _service = ProfileService();
  late Future<UserModel?> _userInfoFuture;
  late Future<List<DateTime>> _attendanceFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _service.getUserInfo();
    _attendanceFuture = _service.getAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.colorWhite,
      appBar: AppBar(
        backgroundColor: ColorTheme.colorWhite,
        title: const Text('마이페이지'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<UserModel?>(
        future: _userInfoFuture,
        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('오류가 발생했습니다.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('사용자 정보를 찾을 수 없습니다.'));
          }

          var userData = snapshot.data!;
          final List<Map<String, dynamic>> learningStatusItems = [
            {'title': '수료 완료', 'onTap': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompletionPage(uid: userData.uid!)),
              );
            }},
            {'title': '학습 진도', 'onTap': () {}},
            {'title': '용어 목록', 'onTap': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkPage()),
              );
            }},
            {'title': '시나리오 기록', 'onTap': () {}},
          ];

          final List<Map<String, dynamic>> customerServiceItems = [
            {'title': 'FAQ', 'onTap': () {}},
            {'title': '공지사항', 'onTap': () {}},
            {'title': '문의하기', 'onTap': () {}},
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/person.png'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userData.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(userData.email),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const ListTile(
                  title: Text(
                    '잔고 내역',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BalanceDetailPage(balance: userData.balance)),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_balance_wallet, color: Colors.blueGrey),
                            const SizedBox(width: 16),
                            Text(
                              '${userData.balance}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const ListTile(
                  title: Text(
                    '출석 현황',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                FutureBuilder<List<DateTime>>(
                  future: _attendanceFuture,
                  builder: (BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('출석 현황을 불러오는 중 오류가 발생했습니다.'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('출석 기록이 없습니다.'));
                    }

                    List<DateTime> attendance = snapshot.data!;
                    return buildSectionCard(
                      context,
                      children: buildAttendanceWeek(context, attendance),
                    );
                  },
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
                }).toList(),
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
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}

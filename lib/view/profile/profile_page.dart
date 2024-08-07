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
import 'profile_detail_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _service = ProfileService();
  late Future<UserModel?> _userInfoFuture;
  late Future<List<DateTime>> _attendanceFuture;
  UserModel? userData;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _service.getUserInfo();
    _attendanceFuture = _service.getAttendance();
  }

  void _updateUserData(UserModel updatedData) {
    setState(() {
      userData = updatedData;
    });
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

          userData = userData ?? snapshot.data!;
          final List<Map<String, dynamic>> learningStatusItems = [
            {'title': '수료 완료', 'onTap': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompletionPage(uid: userData!.uid!)),
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
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/person.png'),
                  ),
                  title: Text(userData!.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(userData!.email),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  onTap: () async {
                    final updatedUserData = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileDetailPage(userData: userData!)),
                    );
                    if (updatedUserData != null) {
                      _updateUserData(updatedUserData);
                    }
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
                ListTile(
                  leading: Icon(Icons.account_balance_wallet, color: Colors.blueGrey),
                  title: Text(
                    '${userData!.balance}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BalanceDetailPage(balance: userData!.balance)),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const ListTile(
                  title: Text(
                    '출석 현황',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
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

                    List<DateTime> attendance = snapshot.data ?? [];

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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
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

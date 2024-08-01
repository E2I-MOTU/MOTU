import 'package:flutter/material.dart';
import '../../model/user_data.dart';
import '../../service/profile_service.dart';
import '../theme/color_theme.dart';
import 'attendance_screen.dart';
import 'balance_detail_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _service = ProfileService();
  late Future<UserModel?> _userInfoFuture;
  late Future<List<DateTime>> _attendanceFuture;
  late Future<List<Map<String, dynamic>>> _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _service.getUserInfo();
    _attendanceFuture = _service.getAttendance();
    _bookmarksFuture = _service.getBookmarks();
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/image.png'),
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
                    return _buildSectionCard(
                      context,
                      title: '출석 현황',
                      children: _buildAttendanceWeek(attendance),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  context,
                  title: '학습 현황',
                  children: const [
                    Text('학습 현황 내용'),
                  ],
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _bookmarksFuture,
                  builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('저장된 용어 목록을 불러오는 중 오류가 발생했습니다.'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('저장된 용어가 없습니다.'));
                    }

                    List<Map<String, dynamic>> bookmarks = snapshot.data!;
                    return _buildSectionCard(
                      context,
                      title: '최근 저장한 용어 목록',
                      children: bookmarks.map((bookmark) {
                        return _buildListTile(
                          title: bookmark['term'],
                          subtitle: bookmark['definition'],
                          onTap: () {},
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // 다양한 메뉴를 ListView로 작성
                Container(
                  height: MediaQuery.of(context).size.height * 0.3, // 적당한 높이 설정
                  child: ListView(
                    children: [
                      _buildMenuTile(
                        icon: Icons.settings,
                        title: '설정',
                        onTap: () {
                          // Navigate to settings page
                        },
                      ),
                      _buildMenuTile(
                        icon: Icons.help,
                        title: '도움말',
                        onTap: () {
                          // Navigate to help page
                        },
                      ),
                      _buildMenuTile(
                        icon: Icons.feedback,
                        title: '피드백',
                        onTap: () {
                          // Navigate to feedback page
                        },
                      ),
                      _buildMenuTile(
                        icon: Icons.notifications,
                        title: '알림',
                        onTap: () {
                          // Navigate to notifications page
                        },
                      ),
                      _buildMenuTile(
                        icon: Icons.logout,
                        title: '로그아웃',
                        onTap: () {
                          // Handle logout action
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildAttendanceWeek(List<DateTime> attendance) {
    List<Widget> weekWidgets = [];
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    DateTime startDate = DateTime.now();
    for (int i = 1; i < attendance.length; i++) {
      if (attendance[i].difference(attendance[i - 1]).inDays > 1) {
        startDate = attendance[i];
      }
    }

    for (int i = 0; i < 7; i++) {
      DateTime day = startDate.add(Duration(days: i));
      bool isChecked = attendance.any((date) => date.year == day.year && date.month == day.month && date.day == day.day);

      weekWidgets.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AttendanceScreen()),
              );
            },
            child: Column(
              children: [
                Text(weekdays[day.weekday - 1], style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isChecked ? ColorTheme.colorPrimary : ColorTheme.colorDisabled,
                  ),
                  child: Icon(
                    isChecked ? Icons.check : Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: weekWidgets,
      ),
    ];
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    IconData? leadingIcon,
    Widget? leadingWidget,
    required String title,
    String? subtitle,
    Widget? trailing,
    GestureTapCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: leadingWidget ?? (leadingIcon != null ? Icon(leadingIcon) : null),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
    );
  }
}

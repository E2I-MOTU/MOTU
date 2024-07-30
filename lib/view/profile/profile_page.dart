import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../service/profile_service.dart';

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
      appBar: AppBar(
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
                    // CircleAvatar(
                    //   radius: 30,
                    //   backgroundImage: AssetImage('assets/image.png'),
                    // ),
                    // 여기에 사진 넣으면 됨!
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(context, '수료 현황', Icons.check_circle),
                    _buildActionButton(context, '시나리오 기록', Icons.history),
                    _buildActionButton(context, '잔고 내역', Icons.account_balance_wallet),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  context,
                  title: '잔고',
                  children: [
                    _buildListTile(
                      leadingIcon: Icons.account_balance_wallet,
                      title: '잔고',
                      subtitle: '${userData.balance} 원',
                    ),
                  ],
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
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildAttendanceWeek(List<DateTime> attendance) {
    List<Widget> weekWidgets = [];

    DateTime startDate = attendance.first;
    for (int i = 1; i < attendance.length; i++) {
      if (attendance[i].difference(attendance[i - 1]).inDays > 1) {
        startDate = attendance[i];
      }
    }

    for (int i = 0; i < 7; i++) {
      DateTime day = startDate.add(Duration(days: i));
      bool isChecked = attendance.any((date) => date.year == day.year && date.month == day.month && date.day == day.day);
      weekWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Icon(isChecked ? Icons.check_circle : Icons.radio_button_unchecked, color: isChecked ? Colors.green : Colors.grey),
              const SizedBox(width: 10),
              Text('${day.year}-${day.month}-${day.day}'),
            ],
          ),
        ),
      );
    }

    return weekWidgets;
  }

  Widget _buildActionButton(BuildContext context, String title, IconData icon) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          onPressed: () {},
        ),
        Text(title),
      ],
    );
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
}

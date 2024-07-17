import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../service/profile_service.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _controller = ProfileController();
  late Future<UserModel?> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _controller.getUserInfo();
  }

  Future<void> _updateName(BuildContext context, String currentName) async {
    final TextEditingController _nameController = TextEditingController(text: currentName);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이름 수정'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '이름을 입력하세요',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('저장'),
              onPressed: () async {
                await _controller.updateName(_nameController.text);
                setState(() {
                  _userInfoFuture = _controller.getUserInfo();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
      ),
      body: FutureBuilder<UserModel?>(
        future: _userInfoFuture,
        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSectionCard(
                  context,
                  title: '개인 정보',
                  children: [
                    _buildListTile(
                      leadingIcon: Icons.email,
                      title: '이메일',
                      subtitle: userData.email,
                    ),
                    _buildListTile(
                      leadingIcon: Icons.account_circle,
                      title: '이름',
                      subtitle: userData.name,
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _updateName(context, userData.name);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  context,
                  title: '계좌 정보',
                  children: [
                    _buildListTile(
                      leadingIcon: Icons.account_balance_wallet,
                      title: '잔고',
                      subtitle: '${userData.balance} 원',
                    ),
                    _buildListTile(
                      leadingIcon: Icons.history,
                      title: '최근 거래 내역',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
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

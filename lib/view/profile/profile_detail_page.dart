import 'package:flutter/material.dart';
import 'package:motu/view/profile/profile_edit_page.dart';
import '../../model/user_data.dart';

class ProfileDetailPage extends StatelessWidget {
  final UserModel userData;

  const ProfileDetailPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 프로필'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedUserData = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage(userData: userData)),
              );
              if (updatedUserData != null) {
                // Replace the current user data with the updated data
                Navigator.pop(context, updatedUserData);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/person.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userData.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(userData.email, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('잔고: ${userData.balance}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text('출석 기록', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...userData.attendance.map((date) => Text(date.toString())).toList(),
          ],
        ),
      ),
    );
  }
}

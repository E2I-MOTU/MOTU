import 'package:flutter/material.dart';
import 'package:motu/service/auth_service.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart'; // ColorTheme import

class ProfileDetailPage extends StatefulWidget {
  String userName;
  ProfileDetailPage({super.key, required this.userName});

  @override
  ProfileDetailPageState createState() => ProfileDetailPageState();
}

class ProfileDetailPageState extends State<ProfileDetailPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, service, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorTheme.colorWhite,
          title: const Text('내 정보 관리'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage('assets/images/profile/profile_image1.png'),
                ),
                const SizedBox(height: 16),
                const Text(
                  '프로필 사진',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorTheme.Black1,
                  ),
                ),
                const SizedBox(height: 32),
                LayoutBuilder(
                  builder: (context, constraints) {
                    double textFieldWidth = constraints.maxWidth * 0.7;
                    double labelWidth = constraints.maxWidth * 0.2;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildLabeledTextField(
                          controller:
                              TextEditingController(text: service.user.email),
                          label: '이메일',
                          width: textFieldWidth,
                          labelWidth: labelWidth,
                          canEditing: false,
                        ),
                        const SizedBox(height: 16),
                        _buildLabeledTextField(
                          controller: _nameController,
                          label: '이름',
                          width: textFieldWidth,
                          labelWidth: labelWidth,
                          canEditing: true,
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () async {
                            await service.updateUserInfo(_nameController.text);
                            toastification.show(
                              type: ToastificationType.success,
                              title: const Text("알림"),
                              description: const Text("성공적으로 이름이 변경되었습니다."),
                              autoCloseDuration: const Duration(seconds: 2),
                              alignment: Alignment.bottomCenter,
                              showProgressBar: false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorTheme.Purple1,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 38, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '저장하기',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLabeledTextField({
    required TextEditingController controller,
    required String label,
    required double width,
    required double labelWidth,
    required bool canEditing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: ColorTheme.Black1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: width,
          child: TextField(
            controller: controller,
            style: TextStyle(
              fontSize: 15,
              color: canEditing ? ColorTheme.Black1 : ColorTheme.Black4,
            ),
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              filled: true,
              fillColor: ColorTheme.Grey1,
            ),
            enabled: canEditing,
          ),
        ),
      ],
    );
  }
}

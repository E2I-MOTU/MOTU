import 'package:flutter/material.dart';
import 'package:motu/view/theme/color_theme.dart'; // ColorTheme import

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  ProfileDetailPageState createState() => ProfileDetailPageState();
}

class ProfileDetailPageState extends State<ProfileDetailPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  double textFieldWidth = constraints.maxWidth * 0.6;
                  double labelWidth = constraints.maxWidth * 0.2;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildLabeledTextField(
                        controller: TextEditingController(text: 'dd'),
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
                        onPressed: () {},
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

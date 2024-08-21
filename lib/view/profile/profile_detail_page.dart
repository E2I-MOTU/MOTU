import 'package:flutter/material.dart';
import 'package:motu/view/theme/color_theme.dart'; // ColorTheme import
import '../../model/user_model.dart';
import '../../service/profile_service.dart';

class ProfileDetailPage extends StatefulWidget {
  final UserModel userData;

  const ProfileDetailPage({super.key, required this.userData});

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  final ProfileService _service = ProfileService();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  bool _isEditing = false;

  late String initialName;
  late String initialEmail;

  @override
  void initState() {
    super.initState();
    initialName = widget.userData.name;
    initialEmail = widget.userData.email;

    _nameController = TextEditingController(text: initialName);
    _emailController = TextEditingController(text: initialEmail);
    _phoneController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
  }

  Future<void> _saveProfile() async {
    await _service.updateUserInfo(
      widget.userData.uid,
      _nameController.text,
      _emailController.text,
    );

    UserModel updatedUserData = UserModel(
      uid: widget.userData.uid,
      email: _emailController.text,
      name: _nameController.text,
      photoUrl: widget.userData.photoUrl,
      balanceHistory: widget.userData.balanceHistory,
      completedTerminalogy: widget.userData.completedTerminalogy,
      completedQuiz: widget.userData.completedQuiz,
      scenarioRecord: widget.userData.scenarioRecord,
      balance: widget.userData.balance,
      attendance: widget.userData.attendance,
    );

    Navigator.pop(context, updatedUserData);
  }

  void _cancelEditing() {
    setState(() {
      _nameController.text = initialName;
      _emailController.text = initialEmail;
      _isEditing = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
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
                backgroundImage: AssetImage('assets/images/person.png'),
              ),
              const SizedBox(height: 8),
              const Text(
                '프로필 사진',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  double textFieldWidth = constraints.maxWidth * 0.7;
                  double labelWidth = constraints.maxWidth * 0.2;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildLabeledTextField(
                        controller: _nameController,
                        label: '이름',
                        width: textFieldWidth,
                        labelWidth: labelWidth,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        controller: _emailController,
                        label: '이메일',
                        width: textFieldWidth,
                        labelWidth: labelWidth,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        controller: _phoneController,
                        label: '전화번호',
                        width: textFieldWidth,
                        labelWidth: labelWidth,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        controller: _passwordController,
                        label: '비밀번호',
                        obscureText: true,
                        width: textFieldWidth,
                        labelWidth: labelWidth,
                      ),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
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
    bool obscureText = false,
    required double width,
    required double labelWidth,
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
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: width,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            enabled: _isEditing,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_isEditing) {
                _saveProfile();
              }
              _isEditing = !_isEditing;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorTheme.colorPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            _isEditing ? '저장' : '편집',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        if (_isEditing) const SizedBox(width: 16),
        if (_isEditing)
          ElevatedButton(
            onPressed: _cancelEditing,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorTheme.colorNeutral,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '취소',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}

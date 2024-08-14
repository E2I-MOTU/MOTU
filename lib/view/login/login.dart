import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../main_page.dart';
import '../theme/color_theme.dart';
import 'register.dart';
import 'package:motu/provider/navigation_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용자 정보를 찾을 수 없습니다.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? '로그인 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.colorWhite,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              Text(
                '모두를 위한 투자 공부',
                style: TextStyle(
                  fontSize: 18,
                  color: ColorTheme.colorFont, // 색상 적용
                ),
              ),
              Text(
                'MOTU',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: ColorTheme.colorPrimary, // 색상 적용
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: '이메일을 입력하세요',
                  labelStyle: TextStyle(color: ColorTheme.colorDisabled), // 색상 적용
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorTheme.colorPrimary), // 포커스 시 색상 적용
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: '비밀번호를 입력하세요',
                  labelStyle: TextStyle(color: ColorTheme.colorDisabled), // 색상 적용
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorTheme.colorPrimary), // 포커스 시 색상 적용
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                        activeColor: ColorTheme.colorPrimary,
                      ),
                      const Text('로그인 유지'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      '아이디/비밀번호 찾기',
                      style: TextStyle(color: ColorTheme.colorFont),
                    ),
                    style: TextButton.styleFrom(
                      overlayColor: ColorTheme.colorPrimary, // 클릭 시 색상 적용
                      //색 안나오게 하려면 Colors.transparent
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _login,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ColorTheme.colorPrimary),
                    backgroundColor: ColorTheme.colorWhite,
                    overlayColor: ColorTheme.colorPrimary // 클릭 시 배경색 적용
                  ),
                  child: Text('로그인', style: TextStyle(color: ColorTheme.colorPrimary)), // 색상 적용
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme.colorPrimary, // 색상 적용
                  ),
                  child: const Text('회원가입', style: TextStyle(color: ColorTheme.colorWhite),),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '간편로그인',
                      style: TextStyle(color: ColorTheme.colorDisabled),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Google 로그인 로직 추가
                  },
                  icon: Icon(Icons.login, color: ColorTheme.colorPrimary), // 색상 적용
                  label: Text('Google 아이디로 로그인', style: TextStyle(color: ColorTheme.colorPrimary)), // 색상 적용
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ColorTheme.colorPrimary), // 색상 적용
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

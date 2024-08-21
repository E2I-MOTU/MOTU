import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:motu/service/auth_service.dart';
import 'package:provider/provider.dart';
import '../main_page.dart';
import '../theme/color_theme.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool viewPassword = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<AuthService>(builder: (context, service, child) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: ColorTheme.colorWhite,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/login/login_logo.png',
                    width: size.width * 0.4,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: size.height * 0.1),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      filled: true,
                      fillColor: ColorTheme.Grey1,
                      hintText: '이메일을 입력하세요',
                      hintStyle: TextStyle(
                        color: ColorTheme.Grey3,
                        fontSize: 14,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: viewPassword ? false : true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      filled: true,
                      fillColor: ColorTheme.Grey1,
                      hintText: '비밀번호를 입력하세요',
                      hintStyle: const TextStyle(
                        color: ColorTheme.Grey3,
                        fontSize: 14,
                      ), // 색상 적용
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            viewPassword = !viewPassword;
                          });
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        icon: viewPassword
                            ? const Icon(Icons.visibility_off,
                                color: ColorTheme.Grey2)
                            : const Icon(Icons.visibility,
                                color: ColorTheme.Grey2),
                        highlightColor: Colors.transparent, // 버튼 클릭 시 색상 효과 제거
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              color: ColorTheme.Purple1,
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: ColorTheme.Purple1,
                        foregroundColor: ColorTheme.White,
                      ),
                      child: const Text(
                        '로그인 하기',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: ColorTheme.Black4,
                          height: 10,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '간편로그인',
                          style: TextStyle(color: ColorTheme.Black4),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: ColorTheme.Black4,
                          height: 64,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        await service.signInWithGoogle();
                        log("로그인 성공: ${service.auth.currentUser!.displayName}");
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: ColorTheme.Black1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: ColorTheme.White,
                        foregroundColor: ColorTheme.Black1,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/login/google_logo.png",
                            width: 16,
                            fit: BoxFit.contain,
                          ),
                          const Text(
                            "Google로 로그인",
                            style: TextStyle(fontSize: 16),
                          ),
                          Opacity(
                            opacity: 0,
                            child: Image.asset(
                              "assets/images/login/google_logo.png",
                              width: 16,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:motu/src/design/color_theme.dart';

class RegisterSuccessPage extends StatelessWidget {
  const RegisterSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/login/register_success.png',
                  width: size.width * 0.5,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                const Text(
                  "회원이 되신 것을",
                  style: TextStyle(
                    fontSize: 25,
                    color: ColorTheme.Purple1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  "축하드려요!",
                  style: TextStyle(
                    fontSize: 25,
                    color: ColorTheme.Purple1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 48),
                const Text("이제 모투와 함께\n경제공부 하러 가볼까요?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorTheme.Black1,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: TextButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: ColorTheme.Purple1,
                  foregroundColor: ColorTheme.White,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "시작하기",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

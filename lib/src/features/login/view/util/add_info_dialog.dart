import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:motu/src/features/login/service/auth_service.dart';

import 'package:motu/src/design/color_theme.dart';
import 'package:provider/provider.dart';

class AddInfoDialog extends StatelessWidget {
  const AddInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    TextEditingController nameController = TextEditingController();

    return Consumer<AuthService>(builder: (context, service, child) {
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.1,
            vertical: size.height * 0.03,
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  child: Column(
                    children: [
                      SizedBox(
                        width: size.width * 0.8,
                        child: TextButton(
                          onPressed: () async {
                            log("🍎 Add Apple User Info");
                            await service.addAppleUserInfo();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: ColorTheme.White,
                            backgroundColor: ColorTheme.Purple1,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                            ),
                          ),
                          child: const Text(
                            "확인",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  const Text(
                    "추가 정보 입력",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "본인 이름을 입력해주세요.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "이름",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

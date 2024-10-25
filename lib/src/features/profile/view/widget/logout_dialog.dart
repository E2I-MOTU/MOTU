import 'package:flutter/material.dart';
import 'package:motu/src/features/login/service/auth_service.dart';
import 'package:motu/src/common/service/navigation_service.dart';
import 'package:motu/src/common/view/widget/motu_button.dart';
import 'package:provider/provider.dart';

Widget LogoutDialog(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return AlertDialog(
    backgroundColor: Colors.white,
    content: Stack(
      children: [
        Positioned(
          right: -10,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: MotuNormalButton(
                    context,
                    text: "아니요",
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MotuCancelButton(
                    context: context,
                    text: "예",
                    onPressed: () {
                      final navigation = Provider.of<NavigationService>(context,
                          listen: false);
                      navigation.setSelectedIndex(0);
                      Provider.of<AuthService>(context, listen: false)
                          .signOut();

                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.3,
          width: size.width * 0.7,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "정말 로그아웃 하실 건가요?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "예를 누르시면 로그아웃 됩니다.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(),
            ],
          ),
        ),
      ],
    ),
  );
}

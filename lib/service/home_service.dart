import 'package:flutter/material.dart';
import '../../service/profile_service.dart';
import '../view/theme/color_theme.dart';

class HomeService {
  final ProfileService _service = ProfileService();

  Future<void> checkAttendance(BuildContext context) async {
    bool confirmed = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(40.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '오늘의 출석 체크를 하시겠습니까?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              Image.asset(
                'assets/images/stamp.png',
                width: 100,
                height: 100,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: ColorTheme.colorDisabled,
                    minimumSize: const Size(100, 30),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: Text(
                    '취소',
                    style: TextStyle(
                      color: ColorTheme.colorBlack,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    confirmed = true;
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: ColorTheme.colorPrimary,
                    minimumSize: const Size(100, 30),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: ColorTheme.colorWhite,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirmed) {
      try {
        await _service.checkAttendance();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '출석 체크가 완료되었습니다!',
              style: TextStyle(color: ColorTheme.colorWhite),
            ),
            backgroundColor: ColorTheme.colorPrimary80,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '오늘은 이미 출석 체크가 완료되었습니다.',
              style: TextStyle(color: ColorTheme.colorWhite),
            ),
            backgroundColor: ColorTheme.colorPrimary80,
          ),
        );
      }
    }
  }
}

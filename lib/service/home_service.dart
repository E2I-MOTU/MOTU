import 'package:flutter/material.dart';
import '../../service/profile_service.dart';

class HomeController {
  final ProfileService _service = ProfileService();

  Future<void> checkAttendance(BuildContext context) async {
    bool confirmed = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('출석 체크'),
          content: const Text('오늘 출석 체크를 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                confirmed = true;
                Navigator.of(context).pop();
              },
              child: const Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('아니오'),
            ),
          ],
        );
      },
    );

    if (confirmed) {
      await _service.checkAttendance();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('출석 체크가 완료되었습니다.')),
      );
    }
  }
}

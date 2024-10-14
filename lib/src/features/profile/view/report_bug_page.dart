import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:motu/src/features/profile/view/widget/info_dialog.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:toastification/toastification.dart';

class ReportBugPage extends StatelessWidget {
  const ReportBugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 34.0),
                  child: Text(
                    "불편하신 점이 있으신가요?",
                    style: TextStyle(
                      color: ColorTheme.Black1,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    '이용 중 불편한 점이나 문의 사항을 알려주세요!',
                    style: TextStyle(
                      color: Color(0xff717171),
                      fontSize: 16,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    '확인 후 신속 정확하게 답변 드리도록 하겠습니다 :)',
                    style: TextStyle(
                      color: Color(0xff717171),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    '평일 (월-금) 10:00 ~ 18:00, 주말 및 공휴일 휴무',
                    style: TextStyle(
                      color: Color(0xff717171),
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 59,
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: ColorTheme.Purple1,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                        ),
                        onPressed: () {
                          sendEmail(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "이메일 보내기",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              CupertinoIcons.chevron_forward,
                              color: Colors.white,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendEmail(BuildContext context) async {
    String body = await _getEmailBody();

    final Email email = Email(
      body: body,
      subject: '[모투 문의 및 버그 제보]',
      recipients: ['e2i.engagetoinnovate@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email).then((value) {
        log('Email sent');
        toastification.show(
          type: ToastificationType.success,
          title: const Text("알림"),
          description: const Text("성공적으로 전송되었습니다!\n빠른 시일 내에 답변드리겠습니다."),
          autoCloseDuration: const Duration(seconds: 2),
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
        );
      });
    } catch (e) {
      // mounted 체크 후 showInfoDialog 호출
      if (context.mounted) {
        showInfoDialog(context);
      }
    }
  }

  void showInfoDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.white,
          content: InfoDialog(),
        );
      },
    );
  }

  Future<String> _getEmailBody() async {
    Map<String, dynamic> appInfo = await _getAppInfo();
    Map<String, dynamic> deviceInfo = await _getDeviceInfo();

    String body = '';

    body += "\n\n";
    body += "==================\n";
    body += "아래 내용을 함께 보내주세요\n";

    appInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    deviceInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    body += "==================\n";

    return body;
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } catch (e) {
      log(e.toString());
      deviceData = {"ERROR": "플랫폼 버전을 불러오는데 실패했습니다."};
    }

    return deviceData;
  }

  Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
    var release = info.version.release;
    var sdkInt = info.version.sdkInt;
    var manufacturer = info.manufacturer;
    var model = info.model;

    return {
      "OS 버전": "Android $release (SDK $sdkInt)",
      "기기": "$manufacturer $model"
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
    var systemName = info.systemName;
    var version = info.systemVersion;
    var machine = info.utsname.machine.iOSProductName;

    return {"OS 버전": "$systemName $version", "기기": machine};
  }

  Future<Map<String, dynamic>> _getAppInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    return {"모투 버전": info.version};
  }
}

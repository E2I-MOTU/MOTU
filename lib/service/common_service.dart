import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:motu/view/profile/widget/info_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:toastification/toastification.dart';

class CommonService with ChangeNotifier {
  void sendEmail(BuildContext context) async {
    String body = await _getEmailBody();

    final Email email = Email(
      body: body,
      subject: '[한밥 제보 및 문의]',
      recipients: ['21900215@handong.ac.kr'],
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
        return const InfoDialog();
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
    return {"한밥 버전": info.version};
  }
}

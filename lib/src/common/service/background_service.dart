import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:motu/src/common/service/notifications.dart';

/*
  시나리오 시스템 백그라운드 서비스
  - global timer 매초 업데이트
  -> 다시 앱 돌아왔을 때 이어서 진행하도록 load
  - remainingTimer 매초 업데이트
  -> 다시 앱 돌아왔을 떄 이어서 진행하도록 load
  - 시나리오 종료 시, 앱 실행시에 시나리오 화면이 뜨도록 설정
*/

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
      autoStart: false,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: false,
      autoStart: false,
      autoStartOnBoot: false,
    ),
  );

  log('🌄 백그라운드 서비스 로드 완료');
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: "시나리오 상황", content: " 입니다!");
      }
    }

    log('Scenario Background Service is running');

    LocalPushNotifications.showSimpleNotification(
        title: "TEST", body: "TEST입니다", payload: "TEST");

////* perform some operation on background which in not noticeable to the used everytime.
    service.invoke('update');
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  log('🌟 iOS background service started');

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    LocalPushNotifications.showSimpleNotification(
        title: "TEST", body: "TEST입니다", payload: "TEST");

    service.invoke('update');
  });

  return true;
}

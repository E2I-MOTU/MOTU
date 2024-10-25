import 'dart:developer';

import 'package:hive/hive.dart';

void setOnboardingDone() {
  final box = Hive.box(name: 'onboarding');
  box.put('done', true);
  log("🐝 로컬DB 저장 : ${box.get('done')}");
}

bool getOnboardingDone() {
  final box = Hive.box(name: 'onboarding');
  bool result = box.get('done') ?? false;
  // log("🐝 로컬DB 조회 : $result");
  return result;
}

void initHiveDB() {
  final box = Hive.box(name: 'scenario');
  log("🐝 로컬DB 초기화 : $box");
}

void setScenarioIsRunning(bool bool) async {
  final box = Hive.box(name: 'scenario');
  box.put('isRunning', bool);
  log("🐝 로컬DB 저장 : ${box.get('isRunning')}");
}

bool getScenarioIsRunning() {
  final box = Hive.box(name: 'scenario');
  bool result = box.get('isRunning') ?? false;
  // log("🐝 로컬DB 조회 : $result");
  return result;
}

void setScenarioStatusData() {
  final box = Hive.box(name: 'scenario');
  box.put('status', {});
}

Object getScenarioStatusData() {
  final box = Hive.box(name: 'scenario');
  return box.get('status');
}

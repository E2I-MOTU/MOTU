import 'package:flutter/material.dart';
import 'package:motu/provider/navigation_provider.dart';
import 'package:motu/service/auth_service.dart';
import 'package:motu/view/profile/completed_quiz_page.dart';
import 'package:motu/view/profile/completed_scenario_page.dart';
import 'package:motu/view/profile/report_bug_page.dart';
import 'package:motu/view/profile/widget/attendance_builder.dart';
import 'package:motu/view/profile/widget/section_builder.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/util.dart';
import '../../widget/chatbot_fab.dart';
import '../terminology/bookmark.dart';
import '../theme/color_theme.dart';
import 'FAQ_page.dart';
import 'balance_detail_page.dart';
import 'completed_term_page.dart';
import 'profile_detail_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  // 개인정보 처리방침 URL
  final Uri _privacyPolicyUrl = Uri.parse("https://amused-power-1c0.notion.site/5704c05a8fdb471a8b23f38b3ecb77f1");

  void _launchURL() async {
    try {
      if (await canLaunchUrl(_privacyPolicyUrl)) {
        await launchUrl(_privacyPolicyUrl);
      } else {
        print("Could not launch the URL: $_privacyPolicyUrl");
      }
    } catch (e) {
      print("Error occurred while trying to launch URL: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, service, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('마이페이지'),
          backgroundColor: ColorTheme.White,
          scrolledUnderElevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                final navigation =
                    Provider.of<NavigationService>(context, listen: false);
                navigation.setSelectedIndex(0);
                service.signOut();
              },
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Image.asset(
                  'assets/images/profile/profile_image1.png',
                  width: 48,
                  height: 48,
                ),
                title: Text(service.user!.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(service.user!.email),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 16.0, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ProfileDetailPage(userName: service.user!.name);
                    }),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                '잔고 내역',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),

              // MARK: - 잔고 내역
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const BalanceDetailPage();
                    }),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                      24.0, 16, 24.0, 16), // 내부 padding

                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/profile/balance_icon.png",
                                width: 18,
                                height: 18,
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                '보유 자산',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ColorTheme.Black3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            Formatter.format(service.user!.balance),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: ColorTheme.colorPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          size: 16.0, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 50,
                color: ColorTheme.Grey2,
              ),
              const Text(
                "출석 현황",
                style: TextStyle(color: ColorTheme.Black2),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<DateTime>>(
                future: service.getAttendance(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DateTime>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('출석 현황을 불러오는 중 오류가 발생했습니다.'));
                  }

                  List<DateTime> attendance = snapshot.data ?? [];

                  return buildSectionCard(
                    context,
                    children: buildAttendanceWeek(context, attendance),
                    backgroundColor: ColorTheme.colorNeutral,
                  );
                },
              ),
              const Divider(
                height: 50,
                color: ColorTheme.Grey2,
              ),
              const Text(
                "학습 현황",
                style: TextStyle(color: ColorTheme.Black2),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const CompletedTermPage();
                    }),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "학습한 용어 목록",
                      style: TextStyle(fontSize: 15, color: ColorTheme.Black1),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: ColorTheme.Black1,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const CompletedQuizPage();
                    }),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "해결한 퀴즈 목록",
                      style: TextStyle(fontSize: 15, color: ColorTheme.Black1),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: ColorTheme.Black1,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const BookmarkPage();
                    }),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "저장한 용어 목록",
                      style: TextStyle(fontSize: 15, color: ColorTheme.Black1),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: ColorTheme.Black1,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const CompletedScenarioPage();
                  }));
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "참여한 시나리오 기록",
                      style: TextStyle(fontSize: 15, color: ColorTheme.Black1),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: ColorTheme.Black1,
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 50,
                color: ColorTheme.Grey2,
              ),
              const Text(
                "고객 센터",
                style: TextStyle(color: ColorTheme.Black2),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const FAQPage();
                    }),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "FAQ",
                      style: TextStyle(fontSize: 15, color: ColorTheme.Black1),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: ColorTheme.Black1,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const ReportBugPage();
                    }),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "문의 및 개선 사항 요청",
                      style: TextStyle(fontSize: 15, color: ColorTheme.Black1),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: ColorTheme.Black1,
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 50,
                color: ColorTheme.Grey2,
              ),
              TextButton(
                onPressed: _launchURL,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "개인정보 처리방침",
                      style: TextStyle(fontSize: 15, color: ColorTheme.Black1),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: ColorTheme.Black1,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _launchURL,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "회원 탈퇴하기",
                      style: TextStyle(fontSize: 15, color: ColorTheme.Black1),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: ColorTheme.Black1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ChatbotFloatingActionButton(),
      );
    });
  }
}

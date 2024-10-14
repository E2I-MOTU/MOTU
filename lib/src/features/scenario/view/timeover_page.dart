import 'package:flutter/material.dart';
import 'package:motu/src/features/login/service/auth_service.dart';
import 'package:motu/src/features/scenario/service/scenario_service.dart';
import 'package:motu/src/features/scenario/view/balance/investment_status_toggle.dart';
import 'package:motu/src/features/scenario/view/balance/sales_record.dart';
import 'package:motu/src/features/scenario/view/comment_intro_page.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:provider/provider.dart';

class TimeoverPage extends StatelessWidget {
  const TimeoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<AuthService>(builder: (context, auth, child) {
      return Consumer<ScenarioService>(builder: (context, scenario, child) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                color: ColorTheme.Purple5,
              ),
              Positioned(
                left: 0,
                top: size.height * 0.2,
                right: 0,
                height: size.height * 0.8,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 48),
                        Text(
                          "${auth.user?.name}님의 결과",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        InvestmentStatusToggle(haveTitle: false),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: Text(
                            scenario.timeoverCommentMsg(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: size.width * 0.5,
                          height: 48,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CommentIntroPage()));
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: ColorTheme.Purple1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "설명 보러가기",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ColorTheme.White,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  weight: 5,
                                  color: ColorTheme.White,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const SalesRecord(),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.13,
                left: (size.width * 0.5) - (size.width * 0.3),
                width: size.width * 0.6,
                child: Image.asset(
                  "assets/images/scenario/timeover.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}

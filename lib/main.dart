import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:motu/service/auth_service.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/firebase_options.dart';
import 'package:motu/provider/terminology_quiz_provider.dart';
import 'package:motu/view/login/login.dart';
import 'package:motu/view/main_page.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';
import 'package:motu/provider/navigation_provider.dart';
import 'package:motu/provider/chat_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ScenarioService()),
        ChangeNotifierProvider(create: (context) => ChatService()),
        ChangeNotifierProvider(create: (context) => NavigationService()),
        ChangeNotifierProvider(create: (_) => TerminologyQuizService()),
      ],
      builder: (context, child) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.initialize();

    return ToastificationWrapper(
      child: MaterialApp(
        title: 'MOTU',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: ColorTheme.Purple1,
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorTheme.White,
            scrolledUnderElevation: 0,
          ),
          scaffoldBackgroundColor: ColorTheme.White,
          fontFamily: "Pretendard",
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: Consumer<AuthService>(builder: (context, service, child) {
          return service.auth.currentUser != null
              ? const MainPage()
              : const LoginPage();
        }),
      ),
    );
  }
}

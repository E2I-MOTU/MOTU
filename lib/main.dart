import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:motu/service/scenario_news_service.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:motu/firebase_options.dart';
import 'package:motu/service/scenario_stock_service.dart';
import 'package:provider/provider.dart';
import 'package:motu/view/login/login.dart';
import 'package:motu/service/navigation_service.dart';
import 'package:motu/service/chat_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScenarioService()),
        ChangeNotifierProvider(create: (context) => ScenarioNewsService()),
        ChangeNotifierProvider(create: (context) => ScenarioStockService()),
        ChangeNotifierProvider(create: (context) => ChatService()),
        ChangeNotifierProvider(create: (context) => NavigationService()),
      ],
      builder: (context, child) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

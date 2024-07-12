import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motu/controller/scenario_service.dart';
import 'package:motu/firebase_options.dart';
import 'package:motu/view/scenario/scenario_chart.dart';
import 'package:motu/view/scenario/scenario_list.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScenarioService()),
      ],
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const InitialPage(),
      home: const ScenarioList(),
    );
  }
}

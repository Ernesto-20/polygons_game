import 'package:circule_game/firebase_options.dart';
import 'package:circule_game/pages/game_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Game Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

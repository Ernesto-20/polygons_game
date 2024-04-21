import 'package:circule_game/pages/game_page.dart';
import 'package:flutter/material.dart';

void main() {
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

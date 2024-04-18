
import 'package:circule_game/pages/game_page.dart';
import 'package:circule_game/widgets/game_panel.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryColor: const Color.fromRGBO(7, 112, 74, 1),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

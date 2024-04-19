import 'package:circule_game/widgets/game_panel.dart';
import 'package:circule_game/widgets/scrore_panel.dart';
import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(40, 43, 45, 1),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 280,
                ),
                const Expanded(child: GamePanel()),
                const FooterPage(),
              ],
            ),
            const ScorePanel(),
          ],
        ),
      ),
    );
  }
}

class FooterPage extends StatelessWidget {
  const FooterPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const Text(
        'version 1.0.0',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w100, fontSize: 12),
      ),
    );
  }
}

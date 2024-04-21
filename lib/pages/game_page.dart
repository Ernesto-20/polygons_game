import 'package:audioplayers/audioplayers.dart';
import 'package:circule_game/blocs/game_pane/game_pane_bloc.dart';
import 'package:circule_game/utils/colors.dart';
import 'package:circule_game/widgets/game_panel.dart';
import 'package:circule_game/widgets/scrore_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final AudioPlayer music;

  @override
  void initState() {
    super.initState();
    music = AudioPlayer();
    music.setVolume(0.01);
    _repeatMusic();
  }

  void _repeatMusic(){
    music
        .play(
      AssetSource('audio/music.mp3'),
    ).then((player) {
      music.onPlayerComplete.listen((event) {
        music.play(AssetSource('audio/music.mp3'),);
        _repeatMusic();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: darkPrimary,
        child: SafeArea(
          child: Container(
            color: darkPrimary,
            width: double.infinity,
            height: double.infinity,
            child: BlocProvider(
              create: (context) => GamePaneBloc(),
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
                            ScorePanel(music: music),
                          ],
                        ),
            ),
          ),
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

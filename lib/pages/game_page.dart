import 'package:audioplayers/audioplayers.dart';
import 'package:circule_game/widgets/game_panel.dart';
import 'package:circule_game/widgets/scrore_panel.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final AudioPlayer music;
  bool enableSound = true;

  @override
  void initState() {
    super.initState();
    music = AudioPlayer();
    music.setVolume(0.01);
    _repeatMusic();
    // .then((player) {
    //   music.play(AssetSource('audio/music.mp3'));
    // });
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
        color: const Color.fromRGBO(30, 33, 35, 1),
        child: SafeArea(
          child: Container(
            color: const Color.fromRGBO(40, 43, 45, 1),
            // color: Colors.white24,
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 280,
                    ),
                    Expanded(child: GamePanel(getEnableSound: getEnableSound)),
                    const FooterPage(),
                  ],
                ),
                ScorePanel(music: music, setEnableSound: setEnableSound, getEnableSound: getEnableSound),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setEnableSound(bool value){
    setState(() {
      enableSound = value;
    });
  }

  bool getEnableSound(){
    return enableSound;
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

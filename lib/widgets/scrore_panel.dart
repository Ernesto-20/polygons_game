import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circule_game/blocs/game_pane/game_pane_bloc.dart';
import 'package:circule_game/models/figure.dart';
import 'package:circule_game/utils/colors.dart';
import 'package:circule_game/widgets/figure_view.dart';
import 'package:circule_game/widgets/others/clip_shadow_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScorePanel extends StatefulWidget {
  const ScorePanel({
    super.key,
    required this.music,
  });

  final AudioPlayer music;

  @override
  State<ScorePanel> createState() => _ScorePanelState();
}

class _ScorePanelState extends State<ScorePanel> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return ClipShadowPath(
          clipper: HeaderClip(),
          shadow: const BoxShadow(color: Colors.black38, blurRadius: 5),
          child: AnimatedContainer(
            padding: const EdgeInsets.only(bottom: 00, top: 00),
            height: isExpanded ? constraints.maxHeight - 28 : 280,
            width: double.infinity,
            color: darkPrimary,
            duration: const Duration(milliseconds: 400),
            child: Stack(
              children: [
                const FloatingFigures(),
                Row(
                  children: [
                    Menu(
                      isExpandedPanel: isExpanded,
                      backHome: backHome,
                      music: widget.music,
                    ),
                    Expanded(
                        child: Row(
                      children: [
                        Container(
                          width: 1,
                          height: constraints.maxHeight * 1,
                          color: const Color.fromRGBO(50, 53, 55, 1),
                        ),
                        Expanded(
                            child: InformationBar(
                                start: start, isExpandedPanel: isExpanded))
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void backHome() {
    setState(() {
      isExpanded = true;
    });
  }

  void start() {
    setState(() {
      isExpanded = false;
    });
  }
}

class InformationBar extends StatelessWidget {
  const InformationBar({
    super.key,
    required this.start,
    required this.isExpandedPanel,
  });
  final durationEffect = const Duration(milliseconds: 400);
  final bool isExpandedPanel;
  final Function start;

  @override
  Widget build(BuildContext context) {
    return _buildContracted(context);
  }

  Widget _buildContracted(BuildContext context) {
    return AnimatedPadding(
      duration: durationEffect,
      padding:
          EdgeInsets.only(top: 50, left: 30, right: isExpandedPanel ? 50 : 30),
      // alignment: Alignment.centerLeft,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.s,
        children: [
          AnimatedContainer(
            duration: durationEffect,
            // padding: isExpandedPanel
            //     ? const EdgeInsets.only(right: 50)
            //     : EdgeInsets.zero,
            // color: Colors.red,
            alignment:
                isExpandedPanel ? Alignment.bottomCenter : Alignment.bottomLeft,
            height: isExpandedPanel ? 220 : 160,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Polygon',
                  style: TextStyle(
                      color: acent, fontWeight: FontWeight.bold, fontSize: 34),
                ),
                const SizedBox(
                  height: 10,
                ),
                AnimatedAlign(
                  duration: durationEffect,
                  alignment:
                      isExpandedPanel ? Alignment.center : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: BlocBuilder<GamePaneBloc, GamePaneState>(
                      builder: (_, state) => Text(
                        'Best: ${state.record}',
                        style: const TextStyle(
                            color: Color.fromRGBO(210, 210, 210, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
                AnimatedAlign(
                  duration: durationEffect,
                  alignment:
                      isExpandedPanel ? Alignment.center : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: BlocBuilder<GamePaneBloc, GamePaneState>(
                      builder: (context, state) {
                        return Text(
                          'Score: ${state.score}',
                          style: const TextStyle(
                              color: Color.fromRGBO(210, 210, 210, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isExpandedPanel,
            child: Expanded(
                child: Container(
              alignment: Alignment.center,
              width: 160,
              child: Material(
                color: darkSecondary,
                borderRadius: BorderRadius.circular(35),
                child: InkWell(
                  borderRadius: BorderRadius.circular(35),
                  splashColor: Colors.white,
                  onTap: () {
                    start();
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35)),
                      child: const Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: acent,
                            size: 60,
                          ),
                          Text('Start',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20))
                        ],
                      )),
                ),
              ),
            )),
          )
          // Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({
    super.key,
    required this.isExpandedPanel,
    required this.backHome,
    required this.music,
  });

  final bool isExpandedPanel;
  final Function backHome;
  final AudioPlayer music;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool enableMusic = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: 80,
      // color: Colors.white60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 30,
          ),
          IconButton(
            onPressed: () {
              widget.backHome();
            },
            icon: const Icon(
              Icons.home_rounded,
              size: 35,
              color: acent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          actionsAlignment: MainAxisAlignment.center,
                          backgroundColor: Theme.of(context).primaryColor,
                          title: const Text(
                            'Hi!',
                            style: TextStyle(
                                color: Color.fromRGBO(210, 210, 210, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                          content: Container(
                            // height: MediaQuery.sizeOf(context).height * 0.7,
                            width: MediaQuery.sizeOf(context).width * 0.85,
                            color: const Color.fromRGBO(40, 43, 45, 1),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        top: 35, left: 20, right: 20),
                                    child: Text(
                                      'All you need is to play!',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(210, 210, 210, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        top: 15,
                                        right: 20,
                                        bottom: 25,
                                        left: 20),
                                    child: Text(
                                      'You will see that it is easy to play, but not so easy to win :(',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(210, 210, 210, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  Container(
                                    // height: 400,
                                    alignment: Alignment.center,
                                    child: CarouselSlider(
                                        options: CarouselOptions(
                                          // height: 350,
                                          enableInfiniteScroll: false,
                                          viewportFraction: 0.7,
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          enlargeStrategy:
                                              CenterPageEnlargeStrategy.height,
                                        ),
                                        items: [
                                          Builder(
                                            builder: (BuildContext context) {
                                              return Image.asset(
                                                'assets/images/one_example.png',
                                                width: 350,
                                                height: 350,
                                                fit: BoxFit.contain,
                                                filterQuality:
                                                    FilterQuality.high,
                                              );
                                            },
                                          ),
                                          Builder(
                                            builder: (BuildContext context) {
                                              return Image.asset(
                                                'assets/images/two_example.png',
                                                width: 350,
                                                height: 350,
                                                fit: BoxFit.contain,
                                                filterQuality:
                                                    FilterQuality.high,
                                              );
                                            },
                                          ),
                                        ]),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ));
              },
              icon: const Icon(
                Icons.question_mark_rounded,
                size: 25,
                color: acent,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: IconButton(
              onPressed: () {
                bool enable = context.read<GamePaneBloc>().state.enableSound;
                context
                    .read<GamePaneBloc>()
                    .add(GamePaneEnabledSound(enable: !enable));
              },
              icon: BlocBuilder<GamePaneBloc, GamePaneState>(
                builder: (context, state) {
                  return Icon(
                    state.enableSound
                        ? Icons.music_note_rounded
                        : Icons.music_off_rounded,
                    size: 33,
                    color: acent,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: BlocBuilder<GamePaneBloc, GamePaneState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    if (state.enableMusic) {
                      setState(() {
                        context
                            .read<GamePaneBloc>()
                            .add(GamePaneEnabledMusic(enable: false));
                        widget.music.pause();
                      });
                    } else {
                      setState(() {
                        context
                            .read<GamePaneBloc>()
                            .add(GamePaneEnabledMusic(enable: true));
                        widget.music.resume();
                      });
                    }
                  },
                  icon: Icon(
                    state.enableMusic
                        ? Icons.volume_up_rounded
                        : Icons.volume_mute_rounded,
                    size: 33,
                    color: acent,
                  ),
                );
              },
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class HeaderClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;

    double heightDesign = 15.0;

    path.lineTo(0, h);
    path.lineTo(w / 4, h - heightDesign);
    path.lineTo(w / 2, h);
    path.lineTo(w * 3 / 4, h - heightDesign);
    path.lineTo(w, h);
    path.lineTo(w, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class FloatingFigures extends StatefulWidget {
  const FloatingFigures({super.key});

  @override
  State<FloatingFigures> createState() => _FloatingFiguresState();
}

class _FloatingFiguresState extends State<FloatingFigures>
    with TickerProviderStateMixin {
  late final AnimationController _controllerMoving;
  late Animation<double> animationMovements;

  @override
  void initState() {
    super.initState();

    _controllerMoving =
        AnimationController(vsync: this, duration: const Duration(seconds: 12))
          ..repeat();
    animationMovements =
        Tween<double>(begin: 0, end: 1).animate(_controllerMoving)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    List<FigureInfo> figures = [
      FigureInfo(id: 0, rowIndex: -1, columnIndex: -1, steps: -1, lvl: 5),
      FigureInfo(id: 1, rowIndex: -1, columnIndex: -1, steps: -1, lvl: 4),
      FigureInfo(id: 2, rowIndex: -1, columnIndex: -1, steps: -1, lvl: 1),
      FigureInfo(id: 3, rowIndex: -1, columnIndex: -1, steps: -1, lvl: 7),
    ];

    return Stack(
      children: [
        Positioned(
          top: -50 * cos(animationMovements.value * 2 * pi),
          right: 30 + 20 * sin(animationMovements.value * 2 * pi),
          // left: 200 + -50*sin(animationMovements.value * 2 * pi) ,
          child: FigureView(
            key: ValueKey(figures[0].id),
            figureInfo: figures[0],
            maxWidth: 40,
            maxHeight: 40,
          ),
        ),
        Positioned(
          top: 300 +
              200 * cos(animationMovements.value * 2 * pi) +
              30 * sin(animationMovements.value * 1 * pi),
          left: 150 +
              100 * cos(animationMovements.value * 2 * pi) +
              10 * sin(animationMovements.value * 1 * pi),
          // left: 200 + -50*sin(animationMovements.value * 2 * pi) ,
          child: FigureView(
            key: ValueKey(figures[1].id),
            figureInfo: figures[1],
            maxWidth: 40,
            maxHeight: 40,
          ),
        ),
        Positioned(
          bottom: 100 + -80 * cos(animationMovements.value * 2 * pi),
          left: 200 + 20 * sin(animationMovements.value * 2 * pi),
          // left: 200 + -50*sin(animationMovements.value * 2 * pi) ,
          child: FigureView(
            key: ValueKey(figures[3].id),
            figureInfo: figures[3],
            maxWidth: 40,
            maxHeight: 40,
          ),
        ),
        Positioned(
          bottom: -10 * cos(animationMovements.value * 2 * pi),
          left: 30 + 20 * sin(animationMovements.value * 2 * pi),
          // left: 200 + -50*sin(animationMovements.value * 2 * pi) ,
          child: FigureView(
            key: ValueKey(figures[2].id),
            figureInfo: figures[2],
            maxWidth: 40,
            maxHeight: 40,
          ),
        ),
      ],
    );
  }
}

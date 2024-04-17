import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:circule_game/figure.dart';
import 'package:circule_game/figure_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const int xDimension = 4;
const int yDimension = 4;

const double gridWidth = 90;
const double gridHeight = 90;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Game Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Move { up, right, down, left }

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Move currentMovement = Move.right;
  late final AnimationController controllerMovements;
  late Animation<double> animationMovements;

  late List<({FigureInfo figure, int availableMovement})> availableSpace = [];

  int serialId = 1;
  late List<FigureInfo> lastState;
  List<FigureInfo> figuresPossitions = [
    FigureInfo(
        id: 0,
        dx: 180,
        dy: 90,
        steps: 0,
        lvl: 1,
        color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
            Random().nextInt(255), 1)),
    FigureInfo(
        id: 1,
        dx: 90,
        dy: 90,
        steps: 0,
        lvl: 3,
        color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
            Random().nextInt(255), 1)),
  ];

  @override
  void initState() {
    super.initState();
    lastState = List.from(figuresPossitions);
    controllerMovements = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    animationMovements =
        Tween<double>(begin: 0, end: 1).animate(controllerMovements)
          ..addListener(() {
            setState(() {
              if (animationMovements.value == 1) {
                for (var figure in figuresPossitions) {
                  switch (currentMovement) {
                    case Move.up:
                      figure.dy -= (figure.steps * gridHeight);
                    case Move.right:
                      figure.dx += (figure.steps * gridWidth);
                    case Move.down:
                      figure.dy += (figure.steps * gridHeight);
                    case Move.left:
                      figure.dx -= (figure.steps * gridWidth);
                  }
                }

                // Combined
                List<FigureInfo> combinedFigures = [];
                List<int> indexDuplicated = [];
                for (int i = 0; i < figuresPossitions.length; i++) {
                  bool isCombined = false;
                  for (int j = i + 1; j < figuresPossitions.length; j++) {
                    if ((figuresPossitions[i].dx == figuresPossitions[j].dx) &&
                        (figuresPossitions[i].dy == figuresPossitions[j].dy) &&
                        !(indexDuplicated.contains(j))) {
                      isCombined = true;
                      indexDuplicated.add(j);
                      if (figuresPossitions[i].id > figuresPossitions[j].id) {
                        combinedFigures.add(figuresPossitions[i]
                          ..lvl = ++figuresPossitions[i].lvl
                          ..id = ++serialId
                          ..levelUp = true
                          ..color = Color.fromRGBO(Random().nextInt(255),
                              Random().nextInt(255), Random().nextInt(255), 1));
                      } else {
                        combinedFigures.add(figuresPossitions[j]
                          ..lvl = ++figuresPossitions[j].lvl
                          ..id = ++serialId
                          ..levelUp = true
                          ..color = Color.fromRGBO(Random().nextInt(255),
                              Random().nextInt(255), Random().nextInt(255), 1));
                      }

                      break;
                    }
                  }
                  if (!isCombined && !indexDuplicated.contains(i)) {
                    combinedFigures.add(figuresPossitions[i]);
                  }
                }

                figuresPossitions = combinedFigures
                  ..sort((a, b) => a.id.compareTo(b.id));

                _addNewFigure();

                // figuresPossitions.add(FigureInfo(id: id, dx: dx, dy: dy, steps: steps, lvl: lvl, color: color))
              }
            });
          });
  }

  @override
  void dispose() {
    controllerMovements.dispose();
    super.dispose();
  }

  void _addNewFigure() async {
    bool notEqual = false;

    if (lastState.length == figuresPossitions.length) {
      for (int i = 0; i < lastState.length; i++) {
        if (lastState[i] != figuresPossitions[i]) {
          notEqual = true;
          break;
        }
      }
    }

    if (!notEqual) {
      // Adding a new figure in the canvas
      ({double dx, double dy}) poss = _getNewPoss();
      figuresPossitions.add(FigureInfo(
          id: ++serialId,
          dx: poss.dx,
          dy: poss.dy,
          steps: 0,
          lvl: 1,
          color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
              Random().nextInt(255), 1)));
      print('Player');
      final player = AudioPlayer();
      player
          .play(AssetSource('audio/beep.mp3'))
          .then((value) => print('Player.play'));
    }

    lastState = List.from(figuresPossitions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: const Color.fromRGBO(40, 43, 45, 1),
      child: GestureDetector(
        onVerticalDragUpdate: (details){
          print('Vertical');
          // Swiping in up direction.
          if (details.delta.dy > 0) {
            print('Down');
            if (!_isTransicion()) {
              _calculateSpace(Move.down);
              currentMovement = Move.down;
              controllerMovements
                ..reset()
                ..forward();
            }
          }
          if (details.delta.dy < 0) {
            print('Up');
            if (!_isTransicion()) {
              _calculateSpace(Move.up);
              currentMovement = Move.up;
              controllerMovements
                ..reset()
                ..forward();
            } 
          }
        },
        onHorizontalDragUpdate: (details) {
          print('Horizontal');
          // Swiping in right direction.
          if (details.delta.dx > 0) {
            print('Right');
            if (!_isTransicion()) {
              _calculateSpace(Move.right);
              currentMovement = Move.right;
              controllerMovements
                ..reset()
                ..forward();
            }
          }
          // Swiping in left direction.
          if (details.delta.dx < 0) {
            print('Left');
            if (!_isTransicion()) {
              _calculateSpace(Move.left);
              currentMovement = Move.left;
              controllerMovements
                ..reset()
                ..forward();
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(),
            Center(
              child: SizedBox(
                // color: Colors.blue.shade100,
                width: xDimension * gridWidth,
                height: yDimension * gridHeight,
                child: Stack(
                  //Canvas desing
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(30, 33, 35, 1),
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    Stack(
                      children: figuresPossitions
                          .map((FigureInfo figure) =>
                              _buildFigureWithPossition(figure))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            // Control
            // _buildMovementController()
          ],
        ),
      ),
    ));
  }

  Positioned _buildFigureWithPossition(FigureInfo figure) {
    return Positioned(
      top: (currentMovement == Move.down)
          ? figure.dy +
              (figure.steps * 90) *
                  (animationMovements.value == 1 ? 0 : animationMovements.value)
          : (currentMovement == Move.up)
              ? figure.dy -
                  (figure.steps * 90) *
                      (animationMovements.value == 1
                          ? 0
                          : animationMovements.value)
              : figure.dy,
      left: currentMovement == Move.right
          ? figure.dx +
              (figure.steps * 90) *
                  (animationMovements.value == 1 ? 0 : animationMovements.value)
          : currentMovement == Move.left
              ? figure.dx -
                  (figure.steps * 90) *
                      (animationMovements.value == 1
                          ? 0
                          : animationMovements.value)
              : figure.dx,
      child: FigureView(
        key: ValueKey(figure.id),
        figureInfo: figure,
      ),
    );
  }

  SizedBox _buildMovementController() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // up
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                  child: IconButton(
                onPressed: () {
                  if (!_isTransicion()) {
                    _calculateSpace(Move.up);
                    currentMovement = Move.up;
                    controllerMovements
                      ..reset()
                      ..forward();
                  }
                },
                icon: const Icon(Icons.arrow_circle_up_rounded),
                iconSize: 50,
              )),
              const Expanded(child: SizedBox()),
            ],
          ),
          // left and right
          Row(
            children: [
              Expanded(
                  child: IconButton(
                onPressed: () {
                  if (!_isTransicion()) {
                    _calculateSpace(Move.left);
                    currentMovement = Move.left;
                    controllerMovements
                      ..reset()
                      ..forward();
                  }
                },
                icon: const Icon(Icons.arrow_circle_left_rounded),
                iconSize: 50,
              )),
              const Expanded(child: SizedBox()),
              Expanded(
                  child: IconButton(
                onPressed: () {
                  if (!_isTransicion()) {
                    _calculateSpace(Move.right);
                    currentMovement = Move.right;
                    controllerMovements
                      ..reset()
                      ..forward();
                  }
                },
                icon: const Icon(Icons.arrow_circle_right_rounded),
                iconSize: 50,
              )),
            ],
          ),
          // down
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                  child: IconButton(
                onPressed: () {
                  if (!_isTransicion()) {
                    _calculateSpace(Move.down);
                    currentMovement = Move.down;
                    controllerMovements
                      ..reset()
                      ..forward();
                  }
                },
                icon: const Icon(Icons.arrow_circle_down_rounded),
                iconSize: 50,
              )),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  bool _isTransicion() =>
      (animationMovements.value > 0 && animationMovements.value < 1);

  void _calculateSpace(Move move) {
    List<({FigureInfo figure, int availableMovement})> available = [];
    _cleanLevelUp();
    switch (move) {
      case Move.up:
        available = _calculateAvailabilityTop();
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);
      case Move.right:
        available = _calculateAvailabilityRight();
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);

      case Move.down:
        available = _calculateAvailabilityDown();
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);

      case Move.left:
        available = _calculateAvailabilityLeft();
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);
    }
  }

  List<({FigureInfo figure, int availableMovement})>
      _calculateAvailabilityTop() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss =
        _initializaedArrayWithCurrentsPossitions();
    List<({FigureInfo figure, int availableMovement})> available = [];

    for (int column = 0; column < yDimension; column++) {
      int availableMovement = 0;
      List<({FigureInfo figure, int availableMovement})> availableInColumn = [];

      bool combined = false;
      for (int row = 0; row < xDimension; row++) {
        if (arrayIndexPoss[column]![row] == null) {
          availableMovement++;
        } else if ((!combined) &&
            (availableInColumn.isNotEmpty) &&
            (availableInColumn.last.figure.id !=
                arrayIndexPoss[column]![row]!.id) &&
            (availableInColumn.last.figure.lvl ==
                arrayIndexPoss[column]![row]!.lvl)) {
          availableMovement++;
          combined = true;

          availableInColumn.add((
            figure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        } else {
          combined = false;
          availableInColumn.add((
            figure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        }
      }

      available = [...available, ...availableInColumn];
    }

    return available;
  }

  List<({FigureInfo figure, int availableMovement})>
      _calculateAvailabilityDown() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss =
        _initializaedArrayWithCurrentsPossitions();
    List<({FigureInfo figure, int availableMovement})> available = [];

    for (int column = 0; column < yDimension; column++) {
      int availableMovement = 0;
      List<({FigureInfo figure, int availableMovement})> availableInColumn = [];

      bool combined = false;
      for (int row = xDimension - 1; row >= 0; row--) {
        if (arrayIndexPoss[column]![row] == null) {
          availableMovement++;
        } else if ((!combined) &&
            (availableInColumn.isNotEmpty) &&
            (availableInColumn.last.figure.id !=
                arrayIndexPoss[column]![row]!.id) &&
            (availableInColumn.last.figure.lvl ==
                arrayIndexPoss[column]![row]!.lvl)) {
          availableMovement++;
          combined = true;

          availableInColumn.add((
            figure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        } else {
          combined = false;
          availableInColumn.add((
            figure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        }
      }

      available = [...available, ...availableInColumn];
    }

    return available;
  }

  List<({FigureInfo figure, int availableMovement})>
      _calculateAvailabilityRight() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss =
        _initializaedArrayWithCurrentsPossitions();
    List<({FigureInfo figure, int availableMovement})> available = [];

    for (int row = 0; row < xDimension; row++) {
      int availableMovement = 0;
      List<({FigureInfo figure, int availableMovement})> availableInRow = [];

      bool combined = false;
      for (int column = yDimension - 1; column >= 0; column--) {
        if (arrayIndexPoss[column]![row] == null) {
          availableMovement++;
        } else if ((!combined) &&
            (availableInRow.isNotEmpty) &&
            (availableInRow.last.figure.id !=
                arrayIndexPoss[column]![row]!.id) &&
            (availableInRow.last.figure.lvl ==
                arrayIndexPoss[column]![row]!.lvl)) {
          availableMovement++;
          combined = true;

          availableInRow.add((
            figure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        } else {
          combined = false;
          availableInRow.add((
            figure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        }
      }

      available = [...available, ...availableInRow];
    }

    return available;
  }

  List<({FigureInfo figure, int availableMovement})>
      _calculateAvailabilityLeft() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss =
        _initializaedArrayWithCurrentsPossitions();
    List<({FigureInfo figure, int availableMovement})> available = [];

    for (int row = 0; row < xDimension; row++) {
      int availableMovement = 0;
      List<({FigureInfo figure, int availableMovement})> availableInRow = [];

      bool combined = false;
      for (int column = 0; column < yDimension; column++) {
        if (arrayIndexPoss[column]![row] == null) {
          availableMovement++;
        } else if ((!combined) &&
            (availableInRow.isNotEmpty) &&
            (availableInRow.last.figure.id !=
                arrayIndexPoss[column]![row]!.id) &&
            (availableInRow.last.figure.lvl ==
                arrayIndexPoss[column]![row]!.lvl)) {
          availableMovement++;
          combined = true;

          availableInRow.add((
            figure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        } else {
          combined = false;
          availableInRow.add((
            figure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        }
      }

      available = [...available, ...availableInRow];
    }

    return available;
  }

  void _refreshFigureWithNewAvailability(
      List<({FigureInfo figure, int availableMovement})> available) {
    List<FigureInfo> temp = [];

    for (({FigureInfo figure, int availableMovement}) aval in available) {
      FigureInfo figure =
          figuresPossitions.firstWhere((e) => e.id == aval.figure.id);
      temp.add(figure..steps = aval.availableMovement);
    }

    figuresPossitions = temp..sort(((a, b) => a.id.compareTo(b.id)));
  }

  Map<int, Map<int, FigureInfo?>> _initializaedArrayWithCurrentsPossitions() {
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss = {};
    for (int i = 0; i < xDimension; i++) {
      // Initialize de array in -1 values.
      arrayIndexPoss[i] = {};
      for (int j = 0; j < yDimension; j++) {
        arrayIndexPoss[i]![j] = null;
      }
    }
    for (int i = 0; i < figuresPossitions.length; i++) {
      int indexRow = figuresPossitions[i].dx ~/ gridWidth;
      int indexColumn = figuresPossitions[i].dy ~/ gridHeight;

      arrayIndexPoss[indexRow]![indexColumn] = figuresPossitions[i];
    }

    return arrayIndexPoss;
  }

  ({double dx, double dy}) _getNewPoss() {
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss =
        _initializaedArrayWithCurrentsPossitions();
    List<({double dx, double dy})> freePosition = [];

    for (int i = 0; i < xDimension; i++) {
      for (int j = 0; j < yDimension; j++) {
        if (arrayIndexPoss[i]![j] == null) {
          freePosition.add((dx: i * gridWidth, dy: j * gridWidth));
        }
      }
    }
    int index = Random().nextInt(freePosition.length);
    return (dx: freePosition[index].dx, dy: freePosition[index].dy);
  }

  void _cleanLevelUp() {
    figuresPossitions.forEach((element) {
      element.levelUp = false;
    });
  }
}

// void _printResultAvailables(
//     List<({FigureInfo figure, int availableMovement})> available) {
//   for (({FigureInfo figure, int availableMovement}) temp in available) {}
// }

// void printArray(Map<int, Map<int, FigureInfo>> array) {
//   for (int i = 0; i < xDimension; i++) {
//     String row = '';
//     for (int j = 0; j < yDimension; j++) {
//       row += '${array[j]![i]} ';
//     }
//     print(row);
//   }
// }

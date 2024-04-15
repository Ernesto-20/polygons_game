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
  late final AnimationController controller;
  late Animation<double> animation;
  late List<({int indexFigure, int availableMovement})> availableSpace = [];

  List<({double dx, double dy, int steps, int lvl})> figuresPossitions = [
    (dx: 90, dy: 90, steps: 0, lvl: 1),
    (dx: 180, dy: 270, steps: 0, lvl: 1)
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value == 1) {
            figuresPossitions = figuresPossitions
                .map((({double dx, double dy, int steps, int lvl}) poss) {
              double dx = poss.dx;
              double dy = poss.dy;
              int steps = poss.steps;
              int lvl = poss.lvl;

              switch (currentMovement) {
                case Move.up:
                  dy -= (steps * gridHeight);
                case Move.right:
                  dx += (steps * gridWidth);
                case Move.down:
                  dy += (steps * gridHeight);
                case Move.left:
                  dx -= (steps * gridWidth);
              }

              return (dx: dx, dy: dy, steps: steps, lvl: lvl);
            }).toList();
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    // print('');
    // print('Move: $Move');
    // print('value: ${animation.value}');
    // print('dx: $dx');
    // print('dy: $dy');
    // print('');

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(),
            Center(
              child: Container(
                color: Colors.blue.shade100,
                width: xDimension * gridWidth,
                height: yDimension * gridHeight,
                child: Stack(
                  children: figuresPossitions
                      .map((({double dx, double dy, int steps, int lvl}) e) => FigureView(
                          dx: e.dx,
                          dy: e.dy,
                          steps: e.steps,
                          currentMovement: currentMovement,
                          animation: animation))
                      .toList(),
                ),
              ),
            ),
            // Control
            _buildMovementController()
          ],
        ));
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
                    controller
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
                    controller
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
                    controller
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
                    controller
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

  bool _isTransicion() => (animation.value > 0 && animation.value < 1);

  void _calculateSpace(Move move) {
    List<({int indexFigure, int availableMovement})> available = [];
    switch (move) {
      case Move.up:
        available = _calculateAvailabilityTop();
        _printResultAvailables(available);
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);
      case Move.right:
        available = _calculateAvailabilityRight();
        _printResultAvailables(available);
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);

      case Move.down:
        available = _calculateAvailabilityDown();
        _printResultAvailables(available);
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);

      case Move.left:
        available = _calculateAvailabilityLeft();
        _printResultAvailables(available);
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);
    }
  }

  List<({int indexFigure, int availableMovement})> _calculateAvailabilityTop() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, int>> arrayIndexPoss = _initializaedArrayWithCurrentsPossitions();
    List<({int indexFigure, int availableMovement})> available = [];

    for (int column = 0; column < yDimension; column++) {
      int availableMovement = 0;
      for (int row = 0; row < xDimension; row++) {
        if (arrayIndexPoss[column]![row] == -1) {
          availableMovement++;
        } else {
          available.add((
            indexFigure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        }
      }
    }

    return available;
  }

  List<({int indexFigure, int availableMovement})>
      _calculateAvailabilityDown() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, int>> arrayIndexPoss = _initializaedArrayWithCurrentsPossitions();
    List<({int indexFigure, int availableMovement})> available = [];

    for (int column = 0; column < yDimension; column++) {
      int availableMovement = 0;
      for (int row = xDimension - 1; row >= 0; row--) {
        if (arrayIndexPoss[column]![row] == -1) {
          availableMovement++;
        } else {
          available.add((
            indexFigure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        }
      }
    }

    return available;
  }

  List<({int indexFigure, int availableMovement})>
      _calculateAvailabilityRight() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, int>> arrayIndexPoss = _initializaedArrayWithCurrentsPossitions();
    List<({int indexFigure, int availableMovement})> available = [];

    for (int row = 0; row < xDimension; row++) {
      int availableMovement = 0;
      for (int column = yDimension - 1; column >= 0; column--) {
        if (arrayIndexPoss[column]![row] == -1) {
          availableMovement++;
        } else {
          available.add((
            indexFigure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        }
      }
    }

    return available;
  }

  List<({int indexFigure, int availableMovement})>
      _calculateAvailabilityLeft() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, int>> arrayIndexPoss = _initializaedArrayWithCurrentsPossitions();
    List<({int indexFigure, int availableMovement})> available = [];

    for (int row = 0; row < xDimension; row++) {
      int availableMovement = 0;
      for (int column = 0; column < yDimension; column++) {
        if (arrayIndexPoss[column]![row] == -1) {
          availableMovement++;
        } else {
          available.add((
            indexFigure: arrayIndexPoss[column]![row]!,
            availableMovement: availableMovement
          ));
        }
      }
    }

    return available;
  }

  void _refreshFigureWithNewAvailability(
      List<({int availableMovement, int indexFigure})> available) {
    List<({double dx, double dy, int steps, int lvl})> temp = [];

    for (({int indexFigure, int availableMovement}) aval in available) {
      ({double dx, double dy, int steps, int lvl}) figure =
          figuresPossitions.elementAt(aval.indexFigure);
      temp.add((dx: figure.dx, dy: figure.dy, steps: aval.availableMovement, lvl: 1));
    }

    figuresPossitions = temp;
  }

  Map<int, Map<int, int>> _initializaedArrayWithCurrentsPossitions() {
    Map<int, Map<int, int>> arrayIndexPoss = {};
    for (int i = 0; i < xDimension; i++) {
      // Initialize de array in -1 values.
      arrayIndexPoss[i] = {};
      for (int j = 0; j < yDimension; j++) {
        arrayIndexPoss[i]![j] = -1;
      }
    }
    for (int i = 0; i < figuresPossitions.length; i++) {
      int indexRow = figuresPossitions[i].dx ~/ gridWidth;
      int indexColumn = figuresPossitions[i].dy ~/ gridHeight;

      arrayIndexPoss[indexRow]![indexColumn] = i;
    }

    return arrayIndexPoss;
  }

  void _printResultAvailables(
      List<({int availableMovement, int indexFigure})> available) {
    for (({int indexFigure, int availableMovement}) temp in available) {
    }
  }

  void printArray(Map<int, Map<int, int>> array) {
    for (int i = 0; i < xDimension; i++) {
      String row = '';
      for (int j = 0; j < yDimension; j++) {
        row += '${array[j]![i]} ';
      }
      print(row);
    }
  }
}

class FigureView extends StatelessWidget {
  const FigureView({
    super.key,
    required this.dx,
    required this.dy,
    required this.steps,
    required this.currentMovement,
    required this.animation,
  });

  final double dx;
  final double dy;
  final int steps;
  final Move currentMovement;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (currentMovement == Move.down)
          ? dy + (steps * 90) * (animation.value == 1 ? 0 : animation.value)
          : (currentMovement == Move.up)
              ? dy - (steps * 90) * (animation.value == 1 ? 0 : animation.value)
              : dy,

      left: currentMovement == Move.right
          ? dx + (steps * 90) * (animation.value == 1 ? 0 : animation.value)
          : currentMovement == Move.left
              ? dx - (steps * 90) * (animation.value == 1 ? 0 : animation.value)
              : dx,

      child: Container(
        width: 90,
        height: 90,
        color: Colors.amber.shade100,
      ),
    );
  }
}

import 'dart:math';

import 'package:circule_game/widgets/others/clip_shadow_path.dart';
import 'package:circule_game/models/figure.dart';
import 'package:flutter/material.dart';

class FigureView extends StatefulWidget {
  const FigureView({
    super.key,
    required this.figureInfo,
    required this.maxWidth,
    required this.maxHeight,
  });

  final FigureInfo figureInfo;
  final double maxWidth;
  final double maxHeight;

  @override
  State<FigureView> createState() => _FigureViewState();
}

class _FigureViewState extends State<FigureView> with TickerProviderStateMixin {
  late final AnimationController controllerLevelUp;
  late Animation<double> animationLevelUp;

  late final AnimationController controllerSpin;
  late Animation<double> animationSpin;

  late final Color color;

  late final CustomClipper<Path> form;
  late double sizeForm;
  late bool isCircule = false;

  @override
  void initState() {
    super.initState();
    sizeForm = 35;

    controllerSpin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    animationSpin = Tween<double>(begin: 0, end: 1).animate(controllerSpin)
      ..addListener(() {
        setState(() {});
      });

    controllerLevelUp = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    animationLevelUp = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controllerLevelUp, curve: Curves.easeInOutExpo))
      ..addListener(() {
        setState(() {});
      });
    if (widget.figureInfo.levelUp) {
      controllerLevelUp.forward();
    }

    if (widget.figureInfo.lvl == 1) {
      form = Triangle();
      color = const Color.fromRGBO(0, 255, 0, 1);
    } else if (widget.figureInfo.lvl == 2) {
      form = Square();
      sizeForm = 30;
      color = const Color.fromRGBO(255, 204, 0, 1);
    } else if (widget.figureInfo.lvl == 3) {
      form = Pentagon();
      color = Colors.blue.shade500;
    } else if (widget.figureInfo.lvl == 4) {
      form = Hexagon();
      color = const Color.fromRGBO(255, 0, 255, 1);
    } else if (widget.figureInfo.lvl == 5) {
      form = Heptagon();
      color = const Color.fromRGBO(0, 206, 209, 1);
    } else if (widget.figureInfo.lvl == 6) {
      form = Octagon();
      color = const Color.fromRGBO(0, 20, 150, 1);
    } else if (widget.figureInfo.lvl == 7) {
      form = Nonagon();
      color = const Color.fromRGBO(255, 0, 0, 1);
    } else if (widget.figureInfo.lvl == 8) {
      form = Decagon();
      color = const Color.fromARGB(255, 71, 0, 79);
    } else if (widget.figureInfo.lvl == 9) {
      form = Undecagon();
      color = const Color.fromRGBO(128, 0, 128, 1);
    } else if (widget.figureInfo.lvl == 10) {
      form = Dodecagon();
      color = const Color.fromRGBO(204, 255, 0, 1);
    }
    // else if (widget.figureInfo.lvl == 11) {
    //   color = Colors.white;
    //   isCircule = true;
    // }
    else {
      // form = Dodecagon();
      isCircule = true;
      color = Colors.white;
    }
  }

  @override
  void dispose() {
    controllerLevelUp.dispose();
    controllerSpin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.maxWidth,
        height: widget.maxWidth,
        // color: Colors.blueGrey,
        alignment: Alignment.center,
        child: _buildTwoDimension());
  }

  Widget _buildTwoDimension() {
    return isCircule ? _buildCircule() : _buildRotatePolygon();
  }

  Widget _buildRotatePolygon() {
    return AnimatedBuilder(
      animation: controllerSpin,
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: controllerSpin.value * 2 * pi,
          child: child,
        );
      },
      child: SizedBox(
          width: widget.figureInfo.levelUp
              ? sizeForm / 2 * animationLevelUp.value + sizeForm / 2
              : sizeForm,
          height: widget.figureInfo.levelUp
              ? sizeForm / 2 * animationLevelUp.value + sizeForm / 2
              : sizeForm,
          child: _buildPolygon()),
    );
  }

  Widget _buildCircule() {
    return AnimatedBuilder(
      animation: controllerSpin,
      builder: ((context, child) => Container(
            width: 40 + 10 * sin(controllerSpin.value * 2 * pi),
            height: 50,
            alignment: Alignment.center,
            child: child,
          )),
      child: Sephere(value: controllerSpin.value),
    );
  }

  Widget _buildPolygon({Color? test, bool text = true}) {
    return ClipShadowPath(
        clipper: form,
        shadow: const BoxShadow(color: Colors.black38, blurRadius: 15),
        child: Container(
            color: test ?? color,
            alignment: Alignment.center,
            child: text
                ? Text(
                    '${widget.figureInfo.lvl + 2}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )
                : null));
  }
}

class Triangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = sqrt(3) / 2 * w;

    Path path = Path();

    const double x0 = 0;
    final double y0 = h;
    final double x1 = w / 2;
    const double y1 = 0;
    final double x2 = w;
    final double y2 = h;

    path.moveTo(x0, y0);
    path.lineTo(x1, y1);
    path.lineTo(x2, y2);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Square extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path = Path();
    path.lineTo(w, 0);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Pentagon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

    for (int i = 0; i < 5; i++) {
      double angle = (i * 2 * pi / 5) - (pi / 2);
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Hexagon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    final double sideLength =
        size.width / 2; // Longitud de un lado del hexágono
    final double centerX =
        size.width / 2; // Coordenada x del centro del hexágono
    final double centerY =
        size.height / 2; // Coordenada y del centro del hexágono

    // Calcular las coordenadas de los vértices del hexágono
    final List<Offset> vertices = List.generate(6, (i) {
      final double theta =
          (i * 2 * pi / 6) + pi / 6; // Ajustar el ángulo para el primer vértice
      return Offset(
          centerX + sideLength * cos(theta), centerY + sideLength * sin(theta));
    });

    // Mover al primer vértice del hexágono
    path.moveTo(vertices[0].dx, vertices[0].dy);
    // Dibujar las líneas que conectan los vértices
    for (int i = 1; i < vertices.length; i++) {
      path.lineTo(vertices[i].dx, vertices[i].dy);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Heptagon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    final double sideLength =
        size.width / 2; // Longitud de un lado del heptágono
    final double centerX =
        size.width / 2; // Coordenada x del centro del heptágono
    final double centerY =
        size.height / 2; // Coordenada y del centro del heptágono

    // Calcular las coordenadas de los vértices del heptágono
    final List<Offset> vertices = List.generate(7, (i) {
      final double theta =
          (i * 2 * pi / 7) - pi / 2; // Ajustar el ángulo para el primer vértice
      return Offset(
          centerX + sideLength * cos(theta), centerY + sideLength * sin(theta));
    });

    // Mover al primer vértice del heptágono
    path.moveTo(vertices[0].dx, vertices[0].dy);
    // Dibujar las líneas que conectan los vértices
    for (int i = 1; i < vertices.length; i++) {
      path.lineTo(vertices[i].dx, vertices[i].dy);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Octagon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    final double sideLength =
        size.width / 2; // Longitud de un lado del octágono
    final double centerX =
        size.width / 2; // Coordenada x del centro del octágono
    final double centerY =
        size.height / 2; // Coordenada y del centro del octágono

    // Calcular las coordenadas de los vértices del octágono
    final List<Offset> vertices = List.generate(8, (i) {
      final double theta =
          (i * 2 * pi / 8) - pi / 8; // Ajustar el ángulo para el primer vértice
      return Offset(
          centerX + sideLength * cos(theta), centerY + sideLength * sin(theta));
    });

    // Mover al primer vértice del octágono
    path.moveTo(vertices[0].dx, vertices[0].dy);
    // Dibujar las líneas que conectan los vértices
    for (int i = 1; i < vertices.length; i++) {
      path.lineTo(vertices[i].dx, vertices[i].dy);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Nonagon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    final double sideLength =
        size.width / 2; // Length of one side of the nanogon
    final double centerX =
        size.width / 2; // x-coordinate of the center of the nanogon
    final double centerY =
        size.height / 2; // y-coordinate of the center of the nanogon

    // Calculate the coordinates of the vertices of the nanogon
    final List<Offset> vertices = List.generate(9, (i) {
      final double theta =
          (i * 2 * pi / 9) - pi / 9; // Adjust the angle for the first vertex
      return Offset(
          centerX + sideLength * cos(theta), centerY + sideLength * sin(theta));
    });

    // Move to the first vertex of the nanogon
    path.moveTo(vertices[0].dx, vertices[0].dy);
    // Draw the lines connecting the vertices
    for (int i = 1; i < vertices.length; i++) {
      path.lineTo(vertices[i].dx, vertices[i].dy);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Decagon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    final double sideLength =
        size.width / 2; // Length of one side of the decagon
    final double centerX =
        size.width / 2; // x-coordinate of the center of the decagon
    final double centerY =
        size.height / 2; // y-coordinate of the center of the decagon

    // Calculate the coordinates of the vertices of the decagon
    final List<Offset> vertices = List.generate(10, (i) {
      final double theta =
          (i * 2 * pi / 10) - pi / 10; // Adjust the angle for the first vertex
      return Offset(
          centerX + sideLength * cos(theta), centerY + sideLength * sin(theta));
    });

    // Move to the first vertex of the decagon
    path.moveTo(vertices[0].dx, vertices[0].dy);
    // Draw the lines connecting the vertices
    for (int i = 1; i < vertices.length; i++) {
      path.lineTo(vertices[i].dx, vertices[i].dy);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Undecagon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    final double sideLength =
        size.width / 2; // Length of one side of the undecagon
    final double centerX =
        size.width / 2; // x-coordinate of the center of the undecagon
    final double centerY =
        size.height / 2; // y-coordinate of the center of the undecagon

    // Calculate the coordinates of the vertices of the undecagon
    final List<Offset> vertices = List.generate(11, (i) {
      final double theta =
          (i * 2 * pi / 11) - pi / 11; // Adjust the angle for the first vertex
      return Offset(
          centerX + sideLength * cos(theta), centerY + sideLength * sin(theta));
    });

    // Move to the first vertex of the undecagon
    path.moveTo(vertices[0].dx, vertices[0].dy);
    // Draw the lines connecting the vertices
    for (int i = 1; i < vertices.length; i++) {
      path.lineTo(vertices[i].dx, vertices[i].dy);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Dodecagon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    final double sideLength =
        size.width / 2; // Length of one side of the dodecagon
    final double centerX =
        size.width / 2; // x-coordinate of the center of the dodecagon
    final double centerY =
        size.height / 2; // y-coordinate of the center of the dodecagon

    // Calculate the coordinates of the vertices of the dodecagon
    final List<Offset> vertices = List.generate(12, (i) {
      final double theta =
          (i * 2 * pi / 12) - pi / 12; // Adjust the angle for the first vertex
      return Offset(
          centerX + sideLength * cos(theta), centerY + sideLength * sin(theta));
    });

    // Move to the first vertex of the dodecagon
    path.moveTo(vertices[0].dx, vertices[0].dy);
    // Draw the lines connecting the vertices
    for (int i = 1; i < vertices.length; i++) {
      path.lineTo(vertices[i].dx, vertices[i].dy);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Sephere extends StatelessWidget {
  const Sephere({super.key, required this.value});

  final double value;

  @override
  Widget build(Object context) {
    return Container(
      decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: const [Colors.white38, Colors.white],
              radius: 1.5,
              center: Alignment(sin(value * 2 * pi), tan(value * 2 * pi))),
          color: Colors.white,
          shape: BoxShape.circle),
    );
  }
}

class Pyramid extends StatelessWidget {
  const Pyramid({super.key, required this.value});

  final double value;

  @override
  Widget build(Object context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(sin(value * 2 * pi))
        ..rotateZ(0)
        ..rotateX(-0.1),
      child: Stack(
        children: [
          // Transform(
          //   // correct
          //   alignment: FractionalOffset.bottomCenter,
          //   transform: Matrix4.identity()
          //     ..translate(.0, 0.0, -20.0)
          //     ..rotateX(-0.53),
          //   child: _buildPolygon(color: Colors.blue.shade900, text: false),
          // ),
          Transform(
              alignment: FractionalOffset.bottomCenter,
              transform: Matrix4.identity()
                ..translate(20.0, .0, 0.0)
                ..rotateY(.25 * 2 * pi)
                ..rotateX(0.53),
              child: _buildPolygon(color: Colors.green, text: false)),

          Transform(
              alignment: FractionalOffset.bottomCenter,
              transform: Matrix4.identity()
                ..translate(-20.0, .0, 0.0)
                ..rotateY(.75 * 2 * pi)
                ..rotateX(0.53),
              child: _buildPolygon(color: Colors.green, text: false)),

          Transform(
              // correct
              alignment: FractionalOffset.bottomCenter,
              transform: Matrix4.identity()
                ..translate(0.1, .0, 20.5)
                ..rotateX(0.53),
              child: _buildPolygon(color: Colors.green.shade900, text: false)),
          // ),
        ],
      ),
    );
  }

  Widget _buildPolygon({required Color color, bool text = false}) {
    return ClipPath(
        clipper: Triangle(),
        child: Container(
            color: color,
            alignment: Alignment.center,
            child: text
                ? const Text(
                    '${2}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )
                : null));
  }
}

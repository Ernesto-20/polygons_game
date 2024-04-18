import 'package:circule_game/widgets/others/clip_shadow_path.dart';
import 'package:flutter/material.dart';

class ScorePanel extends StatefulWidget {
  const ScorePanel({
    super.key,
  });

  @override
  State<ScorePanel> createState() => _ScorePanelState();
}

class _ScorePanelState extends State<ScorePanel> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return ClipShadowPath(
          clipper: HeaderClip(),
          shadow: const BoxShadow(color: Colors.black38, blurRadius: 5),
          child: AnimatedContainer(
            padding: const EdgeInsets.only(bottom: 30, top: 90),
            height: isExpanded ? constraints.maxHeight - 28 : 280,
            width: double.infinity,
            color: const Color.fromRGBO(30, 33, 35, 1),
            duration: const Duration(seconds: 1),
            child: Row(
              children: [
                Menu(
                  isExpandedPanel: isExpanded,
                  backHome: backHome,
                ),
                Expanded(
                    child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      alignment: Alignment.center,
                      child: Container(
                        width: 1,
                        height: constraints.maxHeight * 0.8,
                        color: const Color.fromRGBO(50, 53, 55, 1),
                      ),
                    ),
                    Expanded(
                        child: InformationBar(
                            start: start, isExpandedPanel: isExpanded))
                  ],
                )),
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

  final bool isExpandedPanel;
  final Function start;

  @override
  Widget build(BuildContext context) {
    return _buildContracted(context);
  }

  Widget _buildContracted(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      alignment: isExpandedPanel? Alignment.center: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Polygon',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 34),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Text(
                'Best: 150',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              'Score: 150',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Visibility(
            visible: isExpandedPanel,
            child: Expanded(
                child: Container(
              alignment: Alignment.center,
              width: 160,
              child: Material(
                color: const Color.fromRGBO(58, 58, 58, 1),
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
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 60,
                          ),
                          const Text('Start',
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
  });

  final bool isExpandedPanel;
  final Function backHome;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      height: double.infinity,
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 35,
              color: Colors.white,
            ),
          ),
          IconButton(
              onPressed: () {
                print('BACK!');
                widget.backHome();
              },
              icon: Image.asset(
                'assets/images/home.png',
                width: 28,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                size: 33,
                color: Colors.white,
              ),
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

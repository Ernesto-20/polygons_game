import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: 80,
      child: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 15),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                size: 35,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/home.png',
                width: 30,
              )),
          const SizedBox(
            height: 30,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 35,
              color: Colors.white,
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
    path.lineTo(w/4, h-heightDesign);
    path.lineTo(w/2, h);
    path.lineTo(w*3/4, h-heightDesign);
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
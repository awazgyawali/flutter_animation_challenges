import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class SolarSystemLoading extends StatefulWidget {
  final double size;
  SolarSystemLoading({@required this.size});
  @override
  _SolarSystemLoadingState createState() => _SolarSystemLoadingState();
}

class _SolarSystemLoadingState extends State<SolarSystemLoading>
    with SingleTickerProviderStateMixin {
  double value = 0.0;
  @override
  void initState() {
    super.initState();
    AnimationController controller = AnimationController(
      lowerBound: 0.0,
      upperBound: 1.0,
      vsync: this,
      duration: Duration(seconds: 10),
    );
    CurvedAnimation animation =
        CurvedAnimation(parent: controller, curve: Curves.linear);
    controller.addListener(() {
      setState(() {
        value = animation.value;
      });
    });

    controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) controller.forward(from: 0.0);
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: SolarSystemPainter(progress: value),
      ),
    );
  }
}

class SolarSystemPainter extends CustomPainter {
  double progress;
  SolarSystemPainter({this.progress = .4});
  var orbit = Paint()
    ..color = Color(0xffB6BBBE)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  var sun = Paint()..color = Color(0xffFFAB91);

  var planet = Paint()..color = Color(0xff3FF9DC);
  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.width / 2);
    canvas.drawCircle(center, size.width / 10, sun);

    canvas.drawArc(
        Rect.fromLTWH(
            center.dx / 2, center.dy / 2, size.width / 2, size.width / 2),
        0,
        2 * pi,
        false,
        orbit);
    canvas.drawArc(
        Rect.fromLTWH(center.dx / 4, center.dy / 4, 3 * size.width / 4,
            3 * size.width / 4),
        0,
        2 * pi,
        false,
        orbit);
    canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.width), 0, 2 * pi, false, orbit);

    canvas.drawCircle(
        center.translate(size.width / 2 * sin(lerpDouble(0, -2 * pi, progress)),
            size.width / 2 * cos(lerpDouble(0, -2 * pi, progress))),
        7,
        planet);
    canvas.drawCircle(
        center.translate(
            3 * size.width / 8 * sin(lerpDouble(0, -6 * pi, progress)),
            3 * size.width / 8 * cos(lerpDouble(0, -6 * pi, progress))),
        7,
        planet);
    canvas.drawCircle(
        center.translate(size.width / 4 * sin(lerpDouble(0, -12 * pi, progress)),
            size.width / 4 * cos(lerpDouble(0, -12 * pi, progress))),
        7,
        planet);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

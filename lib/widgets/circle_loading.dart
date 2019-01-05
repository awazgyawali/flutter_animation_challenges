import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CircleLoading extends StatefulWidget {
  final double size;
  CircleLoading({@required this.size});
  @override
  _CircleLoadingState createState() => _CircleLoadingState();
}

class _CircleLoadingState extends State<CircleLoading>
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
        painter: CirclePainter(progress: value),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  double progress;
  Color color;
  var orbit, loader;

  CirclePainter({this.progress, this.color = Colors.blue}) {
    orbit = Paint()
      ..color = color.withAlpha(80)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    loader = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.width / 2);

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2), 0,
        2 * pi, false, orbit);
    Gradient g = LinearGradient(colors: [
      color.withAlpha(0),
      color,
      color.withAlpha(0),
    ], stops: [
      0,
      .5,
      0
    ], begin: Alignment.centerLeft, end: Alignment.centerRight);

    loader
      ..shader = g.createShader(Rect.fromCircle(
        center: center,
        radius: size.width / 2,
      ));
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2), 0,
        -pi, false, loader);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

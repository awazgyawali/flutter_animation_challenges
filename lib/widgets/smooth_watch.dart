import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class SmoothWatch extends StatefulWidget {
  final double radius;
  SmoothWatch({@required this.radius});
  @override
  _SmoothWatchState createState() => _SmoothWatchState();
}

class _SmoothWatchState extends State<SmoothWatch>
    with SingleTickerProviderStateMixin {
  DateTime dt = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 20), (t) {
      setState(() {
        dt = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(2 * widget.radius, 2 * widget.radius),
      painter: ClockPainter(
        hourAngle: lerpDouble(
            0, -2 * pi, (dt.hour * 60.0 + dt.minute.toDouble()) / 740.0),
        minuteAngle: lerpDouble(
            0, -2 * pi, (dt.minute * 60.0 + dt.second.toDouble()) / 3600.0),
        secondAngle: lerpDouble(0, -2 * pi,
            (dt.second * 1000.0 + dt.millisecond.toDouble()) / 60000.0),
        radius: widget.radius,
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  double hourAngle, minuteAngle, secondAngle;
  double radius;
  ClockPainter({
    this.radius,
    this.hourAngle,
    this.minuteAngle,
    this.secondAngle,
  });

  Paint centerCircle = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  Paint outerCircle = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  Paint hourHand = Paint()
    ..color = Colors.grey
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 6;

  Paint minuteHand = Paint()
    ..color = Colors.white
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 4;

  Paint secondTriangle = Paint()
    ..color = Colors.white
    ..strokeWidth = 2;

  Paint secondLine = Paint()
    ..color = Colors.white
    ..strokeWidth = 2;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), radius, outerCircle);

    drawMinuteHand(canvas, size, minuteAngle);

    drawSecondPointer(canvas, size, secondAngle);

    drawHourHand(canvas, size, hourAngle);

    drawSecondsLines(canvas, size);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 5, centerCircle);
  }

  getSecondColor(angle) {
    if (angle < secondAngle) return Colors.grey;
    if (angle < secondAngle + pi / 4)
    return Colors.white;
      return Color.lerp(
          Colors.grey, Colors.white, .5);
  }

  drawSecondPointer(Canvas canvas, Size size, double angle) {
    var startAngle = angle - pi / 60;
    var endAngle = angle + pi / 60;

    var x = sin(startAngle);
    var y = cos(startAngle);

    Path path = Path();

    Offset startPoint = Offset(size.width / 2, size.height / 2)
        .translate(-radius * .75 * x, -radius * .75 * y);

    path.moveTo(startPoint.dx, startPoint.dy);

    x = sin(endAngle);
    y = cos(endAngle);

    Offset endPoint = Offset(size.width / 2, size.height / 2)
        .translate(-radius * .75 * x, -radius * .75 * y);

    path.lineTo(endPoint.dx, endPoint.dy);

    x = sin(angle);
    y = cos(angle);

    Offset topPoint = Offset(size.width / 2, size.height / 2)
        .translate(-radius * .80 * x, -radius * .80 * y);

    path.lineTo(topPoint.dx, topPoint.dy);

    canvas.drawPath(path, secondTriangle);
  }

  drawSecondsLines(Canvas canvas, Size size) {
    var angle = 0.0;
    for (var i = 60; i > 0; i--) {
      angle -= pi / 30;

      var x = sin(angle);
      var y = cos(angle);

      var startPoint = Offset(size.width / 2, size.height / 2)
          .translate(-radius * .85 * x, -radius * .85 * y);
      var endPoint = Offset(size.width / 2, size.height / 2)
          .translate(-radius * .95 * x, -radius * .95 * y);
      canvas.drawLine(
        startPoint,
        endPoint,
        secondLine..color = getSecondColor(angle),
      );
    }
  }

  drawHourHand(Canvas canvas, Size size, double angle) {
    var x = sin(angle);
    var y = cos(angle);

    var startPoint =
        Offset(size.width / 2, size.height / 2).translate(-5 * x, -5 * y);
    var endPoint = Offset(size.width / 2, size.height / 2)
        .translate(-radius * .5 * x, -radius * .5 * y);
    canvas.drawLine(startPoint, endPoint, hourHand);
  }

  drawMinuteHand(Canvas canvas, Size size, double angle) {
    var x = sin(angle);
    var y = cos(angle);

    var startPoint =
        Offset(size.width / 2, size.height / 2).translate(-5 * x, -5 * y);
    var endPoint = Offset(size.width / 2, size.height / 2)
        .translate(-radius * .7 * x, -radius * .7 * y);
    canvas.drawLine(startPoint, endPoint, minuteHand);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

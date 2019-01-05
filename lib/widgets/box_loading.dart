import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class BoxesLoading extends StatefulWidget {
  final double size;
  final Color color1, color2, backgroundColor;
  BoxesLoading(
      {@required this.size,
      this.color1 = const Color(0xffFFAB91),
      this.color2 =const Color(0xff3FF9DC),
      this.backgroundColor = Colors.white});
  @override
  _BoxesLoadingState createState() => _BoxesLoadingState();
}

class _BoxesLoadingState extends State<BoxesLoading>
    with SingleTickerProviderStateMixin {
  double value = 0.0;
  @override
  void initState() {
    super.initState();
    AnimationController controller = AnimationController(
      lowerBound: 0.0,
      upperBound: 1.0,
      vsync: this,
      duration: Duration(milliseconds: 650),
    );
    CurvedAnimation animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);
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
    return Stack(
      children: <Widget>[
        Transform.rotate(
          angle: lerpDouble(0, pi / 2, value),
          child: Container(
            height: widget.size,
            width: widget.size,
            decoration: BoxDecoration(
              border: Border.all(color: widget.color1, width: 4),
            ),
          ),
        ),
        Transform.rotate(
          angle: lerpDouble(-pi / 4, -3 * pi / 4, value),
          child: Container(
            height: widget.size,
            width: widget.size,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              border: Border.all(color: widget.color2, width: 4),
            ),
          ),
        )
      ],
    );
  }
}


  import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class RollingSwitch extends StatefulWidget {
  final Color offColor;
  final Color onColor;
  final IconData onIcon;
  final IconData offIcon;
  final String onText;
  final String offText;
  final bool initialValue;
  final Function onValueChanged;

RollingSwitch({
    this.initialValue = false,
    this.onText = "DAY",
    this.offText = "NIGHT",
    this.onIcon = Icons.work,
    this.offIcon = Icons.person_add,
    this.onColor = Colors.blue,
    this.offColor = Colors.red,
    this.onValueChanged,
  });
  @override
  _RollingSwitchState createState() => _RollingSwitchState();
}

class _RollingSwitchState extends State<RollingSwitch>
    with SingleTickerProviderStateMixin {
  Duration duration = Duration(milliseconds: 500);

  AnimationController _controller;
  Animation<double> animation;

  bool isOn = false;
  var value = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, lowerBound: 0.0, upperBound: 1.0, duration: duration);

    animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut  );
    _controller.addListener(() {
      setState(() {
        value = animation.value;
        if (value == 0.0)
          widget.onValueChanged(false);
        else if (value == 1.0) widget.onValueChanged(true);
      });
    });

    if (widget.initialValue) {
      setState(() {
        _controller.value = 1.0;
        isOn = true;
      });
    }
  }

  Text getText(text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isOn) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
        isOn = !isOn;
      },
      child: Container(
        padding: EdgeInsets.all(5),
        width: 130,
        decoration: BoxDecoration(
          color: Color.lerp(widget.offColor, widget.onColor, value),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: Offset(10 * (1 - value), 0),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  height: 40,
                  child: getText(widget.offText),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(10 * value, 0),
              child: Opacity(
                opacity: (1 - value).clamp(0.0, 1.0),
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: getText(widget.onText),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(80 * value, 0),
              child: Transform.rotate(
                angle: lerpDouble(0, 2 * pi, value),
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Icon(widget.offIcon, color: widget.onColor)),
                      Opacity(
                          opacity: (1 - value).clamp(0.0, 1.0),
                          child: Icon(widget.onIcon, color: widget.offColor)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

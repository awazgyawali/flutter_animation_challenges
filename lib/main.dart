import 'dart:math';
import 'dart:ui';
import 'package:animation_challenges/widgets/box_loading.dart';
import 'package:animation_challenges/widgets/circle_loading.dart';
import 'package:animation_challenges/widgets/smooth_watch.dart';
import 'package:animation_challenges/widgets/solar_system_loading.dart';
import 'package:http/http.dart';

import 'package:animation_challenges/widgets/rolling_switch.dart';
import 'package:animation_challenges/widgets/syntax_highlighter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  var stringData = "";

  @override
  void initState() {
    super.initState();
    // get("https://raw.githubusercontent.com/flutter/flutter/master/examples/flutter_gallery/lib/gallery/syntax_highlighter.dart")
    //     .then((res) {
    //   setState(() {
    //     stringData = res.body;
    //   });
    // });
  }

  getTitle(message) {
    return Container(
      padding: EdgeInsets.all(50),
      alignment: Alignment.center,
      child: Text(message,
          style:
              Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff37474F),
        height:double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              getTitle("Solar system loading"),
              SolarSystemLoading(size: 200),
              getTitle("Rolling Switch"),
              RollingSwitch(),
              getTitle("Box Loading"),
              BoxesLoading(
                size: 100,
                backgroundColor: Color(0xff37474F),
              ),
              // getTitle("Circle Loading"),
              // CircleLoading(size: 100),
              SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}

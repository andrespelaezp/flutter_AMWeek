import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:english_words/english_words.dart';
import 'package:sensors/sensors.dart';


void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(new CatchphraseApp());
}

class CatchphraseApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Catchphrase demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Phrase(),
    );

  }


}

class Phrase extends StatefulWidget {

  Phrase({Key key}) : super(key: key);

  @override
  _CatchphraseState createState() => new _CatchphraseState();

}

class _CatchphraseState extends State<Phrase> {

  var wordPair = new WordPair.random();

  static const int right = 0;
  static const int wrong = 0;

  List<double> _accelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {

    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();

    return new GestureDetector(
        onTap: () {
          setState(() { wordPair = WordPair.random(); });
        },
        child : new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //your elements here
            new Directionality(
                textDirection: TextDirection.ltr,
                child:
                new Text(
                  wordPair.first.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                )
            )

          ],
        )
      //)
    );

  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

}

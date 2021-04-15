import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/settings.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  int _counter = 0;
  int _glassSize = 300; // in ml
  dynamic _totalWaterAmount = 0;
  bool _isPowerBtnAddEnabled = false;
  bool _isShakingAddEnabled = false;
  String _unit = 'ml';

  static const platform =
      const MethodChannel('com.example.flutter_application_1/powerBtnCount');
  static const stream =
      const EventChannel('com.example.flutter_application_1/stream');

  StreamSubscription _buttonEventStream;

  _HomeState() {
    if (_buttonEventStream == null) {
      debugPrint('initialize stream');
      _buttonEventStream =
          stream.receiveBroadcastStream().listen(evaluateEvent);
    }
    loadData().then((value) {
      setState(() {
        getPowerButtonCount();
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> getPowerButtonCount() async {
    int counter;
    try {
      final int result = await platform.invokeMethod('getPowerBtnCount');
      counter = result;
    } on PlatformException catch (e) {
      debugPrint(e.message);
      counter = -1;
    }

    _counter += counter;
  }

  Future<void> evaluateEvent(event) async {
    var arr = event.split(',');
    debugPrint(event);
    if (arr[0] == "power") {
      updateCounter(int.parse(arr[1]));
    }
    if (arr[0] == "shake") {
      updateCounter(int.parse(arr[1]));
    }
  }

  Future<void> updateCounter(value) async {
    setState(() {
      _counter += value;
      _totalWaterAmount += value * _glassSize;
      saveCounter();
      saveTotalWater();
    });
  }

  void disableListener() {
    debugPrint('disable');
    if (_buttonEventStream != null) {
      _buttonEventStream.cancel();
      _buttonEventStream = null;
    }
  }

  String displayWaterAmount() {
    dynamic water = _totalWaterAmount;
    if (_totalWaterAmount >= 1000) {
      water = _totalWaterAmount / 1000.0;
      _unit = 'L';
    } else {
      _unit = 'ml';
    }
    return water.toString();
  }

  Future<void> saveCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);
  }

  Future<void> saveTotalWater() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('water', _totalWaterAmount.toDouble());
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = (prefs.getInt('counter') ?? 0);
    _glassSize = (prefs.getInt('size') ?? 0);
    dynamic tmp = (prefs.getDouble('water') ?? 0.0);
    if (tmp >= 1000) {
      _totalWaterAmount = tmp.toDouble();
    } else {
      _totalWaterAmount = tmp.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${displayWaterAmount()} $_unit',
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              'You have drank this many glasses of water:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Glass size: $_glassSize ml',
            ),
            ElevatedButton(
                onPressed: disableListener, child: Text('Stop listening')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await updateCounter(1);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // 
    );
  }
}

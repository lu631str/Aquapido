import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'package:water_tracker/Persistence/SharedPref.dart';
import 'package:water_tracker/models/WaterModel.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentCupCounter = 0;
  int _currentCupSize = 300; // in ml
  int _totalWaterAmount = 0;
  bool _isPowerBtnAddEnabled = false;
  bool _isShakingAddEnabled = false;
  String _unit = 'ml';

  List<WaterModel> history = [];

  static const platform =
      const MethodChannel('com.example.flutter_application_1/powerBtnCount');
  static const stream =
      const EventChannel('com.example.flutter_application_1/stream');

  StreamSubscription _buttonEventStream;

  @override
  void initState() {
    super.initState();
    loadData();

    if (_buttonEventStream == null) {
      debugPrint('initialize stream');
      _buttonEventStream =
          stream.receiveBroadcastStream().listen(evaluateEvent);
    }

    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      addWaterCup(1);
    });
  }

  loadData() async {
    int currentCupSize = await loadCurrentCupSize();
    int counter = await loadCurrentCupCounter();
    int totalWaterAmount = await loadTotalWaterAmount();
    setState(() {
      this._currentCupSize = currentCupSize;
      this._currentCupCounter = counter;
      this._totalWaterAmount = totalWaterAmount;
      getPowerButtonCount();
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

    _currentCupCounter += counter;
  }

  Future<void> evaluateEvent(event) async {
    var arr = event.split(',');
    debugPrint(event);
    if (arr[0] == "power") {
      addWaterCup(int.parse(arr[1]));
    }
    if (arr[0] == "shake") {
      //updateCounter(int.parse(arr[1]));
    }
  }

  Future<void> addWaterCup(value) async {
    setState(() {
      _currentCupCounter += value;
      _totalWaterAmount += value * _currentCupSize;
    });
    saveCurrentCupCounter(_currentCupCounter);
    saveTotalWater(_totalWaterAmount);
    this.history.add(WaterModel(_currentCupSize, DateTime.now()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              '$_currentCupCounter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Glass size: $_currentCupSize ml',
            ),
            Expanded(child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: history.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 22,
                    child: Center(child: Text('Amount: ${history[index].cupSize} - Time: ${DateFormat('kk:mm:ss').format(history[index].dateTime)}')),
                  );
                }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addWaterCup(1);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), //
    );
  }
}

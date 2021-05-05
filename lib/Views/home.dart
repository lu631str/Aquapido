import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'package:water_tracker/Persistence/SharedPref.dart';
import 'package:water_tracker/Persistence/Database.dart';
import 'package:water_tracker/icons/my_flutter_app_icons.dart';
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
      //addWaterCup(1);
    });
  }

  String getDateString(DateTime dateTime) {
    if (isToday(dateTime)) {
      return 'Today';
    } else {
      return DateFormat('dd.MM.yy').format(dateTime);
    }
  }

  loadData() async {
    int currentCupSize = await loadCurrentCupSize();
    int counter = await loadCurrentCupCounter();
    var history = await water();
    setState(() {
      this._currentCupSize = currentCupSize;
      this._currentCupCounter = counter;
      this.history = history.reversed.toList();
      calculateTotalWaterAmount();
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
      //addWaterCup(int.parse(arr[1]));
    }
    if (arr[0] == "shake") {
      //updateCounter(int.parse(arr[1]));
    }
  }

  Future<void> addWaterCup(amountOfCups) async {
    await insertWater(WaterModel(dateTime: DateTime.now(), cupSize: _currentCupSize));
    this.history.insert(0, WaterModel(dateTime: DateTime.now(), cupSize: _currentCupSize));
    setState(() {
      _currentCupCounter += amountOfCups;
      calculateTotalWaterAmount();
    });
    saveCurrentCupCounter(_currentCupCounter);
  }

  void delete(index) async {
    deleteWater(this.history[index]);
    setState(() {
      this.history.removeAt(index);
      calculateTotalWaterAmount();
    });
  }

  void disableListener() {
    debugPrint('disable');
    if (_buttonEventStream != null) {
      _buttonEventStream.cancel();
      _buttonEventStream = null;
    }
  }

  bool isToday(dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return true;
    }
    return false;
  }

  void calculateTotalWaterAmount() {
    num sum = 0;
    this.history.forEach((water) {
      if (isToday(water.dateTime)) {
        sum += water.cupSize;
      }
     });
     this._totalWaterAmount = sum;
  }

  String formatDailyTotalWaterAmount() {
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
              'Stay Hydrated',
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              'Cups today:',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$_currentCupCounter',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text('IMAGE'),
            Text(
              'Water today:',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '${formatDailyTotalWaterAmount()} $_unit',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              'Cup size: $_currentCupSize ml',
            ),
            ListTile(
              title: Text(
                'History',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: history.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 40,
                        child: ListTile(
                          leading: Icon(MyFlutterApp.cup_400ml),
                          title: Text(
                              '${history[index].cupSize}ml ${getDateString(history[index].dateTime)} - ${DateFormat('kk:mm').format(history[index].dateTime)}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              delete(index);
                            },
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addWaterCup(1);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), //
    );
  }
}

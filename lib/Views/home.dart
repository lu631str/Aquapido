import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'package:water_tracker/Persistence/SharedPref.dart';
import 'package:water_tracker/Persistence/Database.dart';
import 'package:water_tracker/Widgets/HistoryListElement.dart';
import 'package:water_tracker/icons/my_flutter_app_icons.dart';
import 'package:water_tracker/models/WaterModel.dart';
import 'package:intl/intl.dart';

typedef void DeleteCallback(int index);

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
  String _unit = 'ml';

  WaterModel _lastDeleted;

  List<WaterModel> _history = [];

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

    ShakeDetector.autoStart(onPhoneShake: () {
      addWaterCup(
          WaterModel(dateTime: DateTime.now(), cupSize: _currentCupSize), 0, 1);
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
      this._history = history.reversed.toList();
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
      addWaterCup(
          WaterModel(dateTime: DateTime.now(), cupSize: _currentCupSize),
          0,
          int.parse(arr[1]));
    }
    if (arr[0] == "shake") {
      addWaterCup(
          WaterModel(dateTime: DateTime.now(), cupSize: _currentCupSize),
          0,
          int.parse(arr[1]));
    }
  }

  Future<void> addWaterCup(waterModel, index, amountOfCups) async {
    await insertWater(waterModel);
    this._history.insert(index, waterModel);
    setState(() {
      _currentCupCounter += amountOfCups;
      calculateTotalWaterAmount();
    });
    saveCurrentCupCounter(_currentCupCounter);
  }

  void delete(index) async {
    deleteWater(this._history[index]);
    this._lastDeleted = this._history[index];
    this._history.removeAt(index);
    setState(() {
      _currentCupCounter--;
      calculateTotalWaterAmount();
    });
    saveCurrentCupCounter(_currentCupCounter);

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Deleted: ${this._lastDeleted.toString()}'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          this.addWaterCup(_lastDeleted, index, 1);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    this._history.forEach((water) {
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
                    itemCount: _history.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          child: HistoryListElement(index,
                              MyFlutterApp.cup_400ml, _history[index], delete));
                    }))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addWaterCup(
              WaterModel(dateTime: DateTime.now(), cupSize: _currentCupSize),
              0,
              1);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

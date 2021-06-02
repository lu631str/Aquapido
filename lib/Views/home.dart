import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'package:water_tracker/Persistence/Database.dart';
import 'package:water_tracker/Widgets/HistoryListElement.dart';
import 'package:water_tracker/icons/my_flutter_app_icons.dart';
import 'package:water_tracker/models/SettingsModel.dart';
import 'package:water_tracker/models/WaterModel.dart';
import 'package:water_tracker/Utils/utils.dart';
import 'package:provider/provider.dart';

typedef void DeleteCallback(int index);

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentCupCounter = 5;
  int _totalWaterAmount = 0;
  String _unit = 'ml';

  List<WaterModel> _history = [];

  static const platform =
      const MethodChannel('com.example.flutter_application_1/powerBtnCount');
  static const stream =
      const EventChannel('com.example.flutter_application_1/stream');

  StreamSubscription _buttonEventStream;

  @override
  void initState() {
    super.initState();
    _loadData();

    if (_buttonEventStream == null) {
      debugPrint('initialize stream');
      _buttonEventStream =
          stream.receiveBroadcastStream().listen(evaluateEvent);
    }

    ShakeDetector.autoStart(onPhoneShake: () {
      _addWaterCup(
          WaterModel(
              dateTime: DateTime.now(),
              cupSize: context.watch<SettingsModel>().cupSize),
          0,
          1);
    });
  }

  _loadData() async {
    var history = await waterList();
    setState(() {
      this._history = history.reversed.toList();
      _calculateTotalWaterAmount();
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
      _addWaterCup(
          WaterModel(
              dateTime: DateTime.now(),
              cupSize: context.watch<SettingsModel>().cupSize),
          0,
          int.parse(arr[1]));
    }
    if (arr[0] == "shake") {
      _addWaterCup(
          WaterModel(
              dateTime: DateTime.now(),
              cupSize: context.watch<SettingsModel>().cupSize),
          0,
          int.parse(arr[1]));
    }
  }

  Future<void> _addWaterCup(waterModel, index, amountOfCups) async {
    if (this._history.first.isPlaceholder) {
      this._history.clear();
    }
    await insertWater(waterModel);
    this._history.insert(index, waterModel);
    setState(() {
      _currentCupCounter += amountOfCups;
      _calculateTotalWaterAmount();
    });
    //saveCurrentCupCounter(_currentCupCounter);
  }

  void _delete(index) async {
    WaterModel waterModel = this._history[index];
    deleteWater(waterModel);

    this._history.removeAt(index);
    setState(() {
      if (_currentCupCounter > 0) {
        _currentCupCounter--;
      }
      _calculateTotalWaterAmount();
    });
    //saveCurrentCupCounter(_currentCupCounter);
    if (this._history.isEmpty) {
      this._loadData();
    }
    this._showUndoSnackBar(index, waterModel);
  }

  void _showUndoSnackBar(index, waterModel) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Deleted: ${waterModel.toString()}'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          this._addWaterCup(waterModel, index, 1);
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

  void _calculateTotalWaterAmount() {
    num sum = 0;
    this._history.forEach((water) {
      if (isToday(water.dateTime)) {
        sum += water.cupSize;
      }
    });
    this._totalWaterAmount = sum;
  }

  String _formatDailyTotalWaterAmount() {
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
              'Water today:',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 170,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cups today:',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        '$_currentCupCounter',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_formatDailyTotalWaterAmount()} $_unit',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cup size:',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        '${context.watch<SettingsModel>().cupSize} ml',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              title: Text(
                'History',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: 2,
                color: Color(0xFFE7F3FF),
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _history.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: HistoryListElement(
                            index,
                            MyFlutterApp.sizeIcons[_history[index].cupSize],
                            _history[index],
                            _delete),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addWaterCup(
              WaterModel(
                  dateTime: DateTime.now(),
                  cupSize: Provider.of<SettingsModel>(context, listen: false)
                      .cupSize),
              0,
              1);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'package:water_tracker/Utils/Constants.dart';
import '../Widgets/HistoryListElement.dart';
import '../Models/SettingsModel.dart';
import '../Models/Water.dart';
import '../Utils/utils.dart';
import 'package:provider/provider.dart';
import '../Models/WaterModel.dart';
import '../src/ReminderNotification.dart';

import 'package:rive/rive.dart';

typedef void DeleteCallback(int index);

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _unit = 'ml';

  static const platform =
      const MethodChannel('com.example.flutter_application_1/powerBtnCount');
  static const stream =
      const EventChannel('com.example.flutter_application_1/stream');

  StreamSubscription _buttonEventStream;

  Artboard _riveArtboard;
  RiveAnimationController _controller;
  SimpleAnimation _animation = SimpleAnimation('100%');

  @override
  void initState() {
    super.initState();
    ReminderNotification.initialize();
    ReminderNotification.checkPermission(context);
    if (_buttonEventStream == null) {
      debugPrint('initialize stream');
      _buttonEventStream =
          stream.receiveBroadcastStream().listen(evaluateEvent);
    }

    ShakeDetector.autoStart(onPhoneShake: () {
      _addWaterCup(
          Water(
              dateTime: DateTime.now(),
              cupSize: context.watch<SettingsModel>().cupSize),
          0,
          1);
    });

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/animations/water-glass.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard.We store a reference to it so we can toggle playback.
        artboard.addController(_controller = _animation);
        setState(() => {
              _riveArtboard = artboard,
              this._controller.isActive = false,
            });
        _updateWaterGlass();
      },
    );
  }

  void _updateWaterGlass() {
    if (_controller != null) {
      setState(() {
        //_controller.isActive = true;
        double currentWater = Provider.of<WaterModel>(context, listen: false)
                .totalWaterAmountPerDay() /
            Provider.of<SettingsModel>(context, listen: false).dailyGoal;
        _animation.instance.reset();
        _animation.instance.advance(currentWater);
        _controller.apply(_riveArtboard, currentWater);
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> evaluateEvent(event) async {
    var arr = event.split(',');
    debugPrint(event);
    if (arr[0] == 'power') {
      _addWaterCup(
          Water(
              dateTime: DateTime.now(),
              cupSize:
                  Provider.of<SettingsModel>(context, listen: false).cupSize),
          0,
          int.parse(arr[1]));
    }
    if (arr[0] == 'shake') {
      _addWaterCup(
          Water(
              dateTime: DateTime.now(),
              cupSize:
                  Provider.of<SettingsModel>(context, listen: false).cupSize),
          0,
          int.parse(arr[1]));
    }
  }

  Future<void> _addWaterCup(water, index, amountOfCups) async {
    if (amountOfCups != 0) {
      Provider.of<WaterModel>(context, listen: false).addWater(index, water);
    }
  }

  void _delete(index) async {
    Water water =
        Provider.of<WaterModel>(context, listen: false).removeWater(index);
    _updateWaterGlass();
    this._showUndoSnackBar(index, water);
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

  String _formatDailyTotalWaterAmount(dynamic water) {
    if (water >= 1000) {
      water = water / 1000.0;
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
          // Invoke 'debug painting' (press 'p' in the console, choose the
          // 'Toggle Debug Paint' action from the Flutter Inspector in Android
          // Studio, or the 'Toggle Debug Paint' command in Visual Studio Code)
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
            SizedBox(
              height: 227,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cups today:',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      FutureBuilder(
                          future:
                              context.watch<WaterModel>().getTotalCupsToday(),
                          builder:
                              (BuildContext context, AsyncSnapshot<int> text) {
                            return new Text(
                              text.data.toString(),
                              style: Theme.of(context).textTheme.headline5,
                            );
                          }),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 180,
                        width: 180,
                        child: _riveArtboard == null
                            ? const SizedBox(height: 20, width: 20)
                            : Rive(artboard: _riveArtboard),
                      ),
                      Text(
                        '${_formatDailyTotalWaterAmount(context.watch<WaterModel>().totalWaterAmountPerDay())} $_unit',
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
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: 2,
                color: Color(0xFFE7F3FF),
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: Provider.of<WaterModel>(context, listen: true)
                        .history
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: HistoryListElement(
                            index,
                            Constants.cupImages[getImageIndex(
                                Provider.of<WaterModel>(context, listen: true)
                                    .history[index]
                                    .cupSize)],
                            Provider.of<WaterModel>(context, listen: true)
                                .history[index],
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
        onPressed: () async {
          _addWaterCup(
              Water(
                  dateTime: DateTime.now(),
                  cupSize: Provider.of<SettingsModel>(context, listen: false)
                      .cupSize),
              0,
              1);
          _updateWaterGlass();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

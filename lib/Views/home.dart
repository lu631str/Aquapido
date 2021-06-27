import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/src/painting/gradient.dart' as gradient;
import 'package:water_tracker/src/DailyGoal.dart';
import 'package:water_tracker/src/Models/DailyGoalModel.dart';

import '../src/Models/SettingsModel.dart';
import '../Widgets/home/CupSizeElement.dart';
import '../Widgets/onboarding/QuickAddDialog.dart';
import '../Widgets/home/HistoryListElement.dart';
import '../src/Water.dart';
import '../src/Utils/utils.dart';
import '../src/Models/WaterModel.dart';
import '../src/Utils/Constants.dart';
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
  static const stream =
      const EventChannel('com.example.flutter_application_1/stream');

  StreamSubscription _buttonEventStream;

  Artboard _riveArtboard;
  RiveAnimationController _controller;
  SimpleAnimation _animation = SimpleAnimation('100%');
  final _myController = TextEditingController(text: '0');
  final int _MAX_ITEM_COUNT = 50;

  @override
  void initState() {
    super.initState();
    ReminderNotification.checkPermission(context);

    if (_buttonEventStream == null) {
      _buttonEventStream =
          stream.receiveBroadcastStream().listen(evaluateEvent);
    }

    if (!Provider.of<SettingsModel>(context, listen: false).dialogSeen)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) => QuickAddDialog(),
        );
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
        setState(() {
          _riveArtboard = artboard;
          this._controller.isActive = false;
        });
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // ====== Handle Shake and Power Button Events

  Future<void> evaluateEvent(event) async {
    final arr = event.split(',');
    if (int.parse(arr[1]) <= 0) return;
    if (arr[0] == 'power') {
      if (Provider.of<SettingsModel>(context, listen: false).powerSettings) {
        _addWaterCup(
            Water(
                dateTime: DateTime.now(),
                cupSize:
                    Provider.of<SettingsModel>(context, listen: false).cupSize,
                addType: AddType.power),
            0,
            int.parse(arr[1]));
      }
    }
    if (arr[0] == 'shake') {
      if (Provider.of<SettingsModel>(context, listen: false).shakeSettings) {
        _addWaterCup(
            Water(
                dateTime: DateTime.now(),
                cupSize:
                    Provider.of<SettingsModel>(context, listen: false).cupSize,
                addType: AddType.shake),
            0,
            int.parse(arr[1]));
      }
    }
  }

  // ======

  void saveCustomSize(customSize, dialogContext, mainContext) {
    setState(() {
      _myController.text = '0';
      Provider.of<SettingsModel>(mainContext, listen: false)
          .addCustomCupSize(customSize);
      Navigator.pop(dialogContext);
    });
  }

  bool isCustomSizeValid(TextEditingController controller) {
    int customSize = int.tryParse(controller.text) ?? -1;
    if (Constants.cupSizes.contains(customSize)) {
      return false;
    }
    if (customSize >= 50 && customSize <= 5000) {
      return true;
    }
    return false;
  }

  void showCustomSizeAddDialog(mainContext) {
    bool isInputValid = false;
    showDialog(
        context: mainContext,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SimpleDialog(
                contentPadding: EdgeInsets.all(16),
                title: const Text('home.add_size.title').tr(),
                children: [
                  TextFormField(
                    controller: _myController,
                    onChanged: (value) {
                      setState(() {
                        isInputValid = isCustomSizeValid(_myController);
                      });
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'home.add_size.hint'.tr(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                            child: const Text('dialog.cancel').tr(),
                            onPressed: () {
                              _myController.text = '0';
                              Navigator.pop(context);
                            }),
                        ElevatedButton(
                          child: const Text('dialog.save').tr(),
                          onPressed: (isInputValid)
                              ? () => saveCustomSize(
                                  int.parse(_myController.text),
                                  context,
                                  mainContext)
                              : null,
                        ),
                      ])
                ],
              );
            },
          );
        });
  }

  void _updateGlassAnimation() {
    if (_controller != null) {
      setState(() {
        double currentWater = Provider.of<WaterModel>(context, listen: false)
                .totalWaterAmountPerDay(DateTime.now()) /
            Provider.of<SettingsModel>(context, listen: false).dailyGoal;
        _animation.instance.reset();
        _animation.instance.advance(currentWater);
        _controller.apply(_riveArtboard, currentWater);
      });
    }
  }

  void _addWaterCup(Water water, int index, int amountOfCups) async {
    if (amountOfCups != 0) {
      if (mounted) {
        Provider.of<WaterModel>(context, listen: false).addWater(index, water);
        double dailyGoal =
            Provider.of<SettingsModel>(context, listen: false).dailyGoal;
        int waterAmount = Provider.of<WaterModel>(context, listen: false)
            .totalWaterAmountPerDay(DateTime.now());
        DateTime newDateTime = DateTime(
            water.dateTime.year, water.dateTime.month, water.dateTime.day);
        Provider.of<DailyGoalModel>(context, listen: false).updateDailyGoal(
            DailyGoal(
                dateTime: newDateTime,
                dailyGoalReached: waterAmount >= dailyGoal));
        if (waterAmount >= dailyGoal) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          final snackBar = SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Text('home.daily_goal_reached').tr(),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  void _delete(index) async {
    Water water =
        Provider.of<WaterModel>(context, listen: false).removeWater(index);

    double dailyGoal =
        Provider.of<SettingsModel>(context, listen: false).dailyGoal;
    int waterAmount = Provider.of<WaterModel>(context, listen: false)
        .totalWaterAmountPerDay(DateTime.now());

    Provider.of<DailyGoalModel>(context, listen: false)
        .removeDailyGoal(water, waterAmount >= dailyGoal);
    _updateGlassAnimation();
    this._showUndoSnackBar(index, water);
  }

  void _showUndoSnackBar(index, water) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('home.undo.deleted'.tr() + ' ${water.toString()}'),
      action: SnackBarAction(
        label: 'home.undo.button'.tr(),
        onPressed: () {
          this._addWaterCup(water, index, 1);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  String _formatDailyTotalWaterAmount(dynamic water) {
    water = water / 1000.0;
    return roundDouble(water.toDouble(), 2).toString();
  }

  @override
  Widget build(BuildContext context) {
    _updateGlassAnimation();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'home.heading',
              style: Theme.of(context).textTheme.headline2,
            ).tr(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: AutoSizeText(
                            'home.cups_today'.tr(),
                            maxLines: 1,
                            minFontSize: 7,
                            style: Theme.of(context).textTheme.headline6,
                          )),
                      FutureBuilder(
                          future:
                              context.watch<WaterModel>().getTotalCupsToday(),
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return Text(
                                '0',
                                style: Theme.of(context).textTheme.headline5,
                              );
                            else if (snapshot.hasData)
                              return Text(
                                snapshot.data.toString(),
                                style: Theme.of(context).textTheme.headline5,
                              );
                            else if (snapshot.hasError) {
                              return Text('Error');
                            } else
                              return Text('None');
                          }),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_formatDailyTotalWaterAmount(context.watch<WaterModel>().totalWaterAmountPerDay(DateTime.now()))}L',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 4),
                            height: MediaQuery.of(context).size.height * 0.23,
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: _riveArtboard == null
                                ? SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Text('Loading'))
                                : Rive(artboard: _riveArtboard),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width * 0.33,
                            top: MediaQuery.of(context).size.height * 0.017,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.outlined_flag_outlined,
                                  color: Color(0xFF49873C),
                                  size: 20,
                                ),
                                Text(
                                  '${Provider.of<SettingsModel>(context, listen: false).dailyGoal / 1000}L',
                                  style: TextStyle(
                                      fontSize: 17, color: Color(0xFF49873C)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _addWaterCup(
                              Water(
                                  dateTime: DateTime.now(),
                                  cupSize: Provider.of<SettingsModel>(context,
                                          listen: false)
                                      .cupSize,
                                  addType: AddType.button),
                              0,
                              1);
                          _updateGlassAnimation();
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: gradient.LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).accentColor
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.32,
                            height: MediaQuery.of(context).size.height * 0.06,
                            alignment: Alignment.center,
                            child: Text(
                              'home.add',
                            ).tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: AutoSizeText(
                            'home.cup_size'.tr(),
                            maxLines: 2,
                            minFontSize: 7,
                            style: Theme.of(context).textTheme.headline6,
                          )),
                      TextButton(
                          child: Row(children: [
                            Text(
                              '${context.watch<SettingsModel>().cupSize}ml ',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Icon(Icons.edit, color: Colors.black),
                          ]),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return SimpleDialog(
                                      contentPadding: const EdgeInsets.all(14),
                                      title:
                                          Text('home.choose_size.title').tr(),
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.55,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: GridView.count(
                                            crossAxisCount: 3,
                                            children: Provider.of<
                                                        SettingsModel>(context,
                                                    listen: true)
                                                .cupSizes
                                                .map((size) => CupSizeElement(
                                                      size: size,
                                                      isCustom: !Constants
                                                          .cupSizes
                                                          .contains(size),
                                                      mainContext: context,
                                                      dialogContext:
                                                          dialogContext,
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            showCustomSizeAddDialog(context);
                                          },
                                          child:
                                              const Text('home.choose_size.add')
                                                  .tr(),
                                        )
                                      ],
                                    );
                                  });
                                });
                          }),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: Provider.of<WaterModel>(context, listen: true)
                              .history
                              .length >
                          _MAX_ITEM_COUNT
                      ? _MAX_ITEM_COUNT
                      : Provider.of<WaterModel>(context, listen: true)
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
          ],
        ),
      ),
    );
  }
}

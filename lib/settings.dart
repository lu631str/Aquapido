import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _selectedValue = 200;

  bool _isPowerBtnAddEnabled = false;
  bool _isShakingAddEnabled = false;

  _SettingsState() {
    loadSize().then((size) {
      setState(() {
        this._selectedValue = 300;
      });
    });

    loadPowerSettings().then((power) {
      setState(() {
        this._isPowerBtnAddEnabled = power;
      });
    });

    loadShakeSettings().then((shake) {
      setState(() {
        this._isShakingAddEnabled = shake;
      });
    });
  }

  void _resetCounter() {
    saveCounter(0);
  }

  void _resetTotalWater() {
    saveTotalWater(0.0);
  }

  Future<void> saveCounter(int newCounter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', newCounter);
  }

  Future<void> saveTotalWater(double newWater) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('water', newWater);
  }

  Future<void> saveSize(int size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('size', size);
  }

  Future<void> savePower(bool isPowerBtnAddEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('power', isPowerBtnAddEnabled);
  }

  Future<void> saveShaking(bool isShakingAddEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shake', isShakingAddEnabled);
  }

  Future<String> loadSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getInt('size') ?? 0).toString();
  }

  Future<bool> loadShakeSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool('shake') ?? false);
  }

  Future<bool> loadPowerSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool('power') ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Glass size: ' + _selectedValue.toString() + 'ml'),
                ElevatedButton(
                    child: Text('Change'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => SimpleDialog(
                                title: Text('Choose Size'),
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(context, 100);
                                      setState(() {
                                        this._selectedValue = 100;
                                      });
                                      saveSize(this._selectedValue);
                                    },
                                    child: const Text(
                                      '100ml',
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(context, 200);
                                      setState(() {
                                        this._selectedValue = 200;
                                      });
                                      saveSize(this._selectedValue);
                                    },
                                    child: const Text(
                                      '200ml',
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(context, 300);
                                      setState(() {
                                        this._selectedValue = 300;
                                      });
                                      saveSize(this._selectedValue);
                                    },
                                    child: const Text(
                                      '300ml',
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(context, 330);
                                      setState(() {
                                        this._selectedValue = 330;
                                      });
                                      saveSize(this._selectedValue);
                                    },
                                    child: const Text(
                                      '330ml',
                                    ),
                                  ),
                                ],
                              ));
                    }),
              ],
            ),
            SwitchListTile(
                value: this._isPowerBtnAddEnabled,
                title: Text('Quick add Power Button'),
                onChanged: (value) {
                  setState(() {
                    this._isPowerBtnAddEnabled = value;
                    this.savePower(value);
                  });
                }),
            SwitchListTile(
                value: this._isShakingAddEnabled,
                title: Text('Quick add Shaking'),
                onChanged: (value) {
                  setState(() {
                    this._isShakingAddEnabled = value;
                    this.saveShaking(value);
                  });
                }),
            SwitchListTile(
                value: false, title: Text('Quick add Drink gesture')),
            OutlinedButton(
                onPressed: _resetCounter, child: Text('Reset water glasses')),
            OutlinedButton(
                onPressed: _resetTotalWater, child: Text('Reset total water'))
          ],
        ),
      ),
    );
  }
}

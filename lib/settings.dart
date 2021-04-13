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
  var _sizes = ['100', '200', '250', '300', '330', '400', '500'];
  String _dropdownValue = '300';

  bool _isPowerBtnAddEnabled = false;
  bool _isShakingAddEnabled = false;

  _SettingsState() {
    loadSize().then((size) {
      setState(() {
        this._dropdownValue = size;
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

  Future<void> saveSize(String size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('size', int.parse(size));
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
                Text('Size in ml: '),
                DropdownButton<String>(
                  items: _sizes
                      .map((String value) => DropdownMenuItem<String>(
                          value: value, child: Text(value)))
                      .toList(),
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      this._dropdownValue = newValue;
                    });
                    saveSize(this._dropdownValue);
                  },
                  value: this._dropdownValue,
                ),
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

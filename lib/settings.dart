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
  var _sizes = ["100", "200", "250", "300", "330", "400", "500"];
  String _dropdownValue = "300";

  _SettingsState() {
    _loadSize().then((value) {
      setState(() {
        _dropdownValue = _dropdownValue;
      });
    });
  }

  void _resetCounter() {
    _saveCounter(0);
  }

  void _resetTotalWater() {
    _saveTotalWater(0.0);
  }

  Future<void> _saveCounter(int newCounter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', newCounter);
  }

  Future<void> _saveTotalWater(double newWater) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('water', newWater);
  }

  Future<void> _saveSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('size', int.parse(_dropdownValue));
  }

  Future<void> _loadSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dropdownValue = (prefs.getInt('size') ?? 0).toString();
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
                    _saveSize();
                  },
                  value: _dropdownValue,
                ),
              ],
            ),
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

import 'package:flutter/material.dart';
import 'package:water_tracker/Persistence/SharedPref.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _selectedValue = 300;

  bool _isPowerBtnAddEnabled = false;
  bool _isShakingAddEnabled = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    bool currentCupSize = await loadPowerSettings();
    bool counter = await loadShakeSettings();
    setState(() {
      this._isPowerBtnAddEnabled = currentCupSize;
      this._isShakingAddEnabled = counter;
    });
  }

  void _resetCounter() {
    saveCurrentCupCounter(0);
  }

  void _resetTotalWater() {
    saveTotalWater(0);
  }

  void addSize() {}

  @override
  Widget build(BuildContext context) {
    loadCurrentCupSize().then((size) {
      setState(() {
        this._selectedValue = size;
      });
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SwitchListTile(
                value: this._isPowerBtnAddEnabled,
                title: Text('Quick add Power Button'),
                onChanged: (value) {
                  setState(() {
                    this._isPowerBtnAddEnabled = value;
                    savePower(value);
                  });
                }),
            SwitchListTile(
                value: this._isShakingAddEnabled,
                title: Text('Quick add Shaking'),
                onChanged: (value) {
                  setState(() {
                    this._isShakingAddEnabled = value;
                    saveShaking(value);
                  });
                }),
            SwitchListTile(
                value: false, title: Text('Quick add Drink gesture')),
            ListTile(
              title: Text('Glass size: ' + _selectedValue.toString() + 'ml'),
              trailing: ElevatedButton(
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
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context, 400);
                                    setState(() {
                                      this._selectedValue = 400;
                                    });
                                    saveSize(this._selectedValue);
                                  },
                                  child: const Text(
                                    '400ml',
                                  ),
                                ),
                                OutlinedButton(
                                    onPressed: addSize, child: Text("Add"))
                              ],
                            ));
                  }),
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

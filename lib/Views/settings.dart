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
  String dropdownValue = 'choose';

  List<int> cupSizes = [100, 200, 300, 330, 400, 500];

  bool _isPowerBtnAddEnabled = false;
  bool _isShakingAddEnabled = false;
  final myController = TextEditingController(text: '187');

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
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

  void saveCustomSize(customSize) {
    setState(() {
      this.cupSizes.add(customSize);
    });
  }

  void closeDialog() {
    Navigator.pop(context);
  }

  List<Widget> createDialogOptions(context) {
    List<Widget> sizeOptions = [];

    cupSizes.forEach((i) {
      return sizeOptions.add(
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, i);
            setState(() {
              this._selectedValue = i;
            });
            saveSize(this._selectedValue);
          },
          child: Text('$i ml'),
        ),
      );
    });
    sizeOptions.add(OutlinedButton(
        onPressed: () {
          setState(() {
            showCustomSizeAddDialog();
          });
        },
        child: Text("Add")));
    return sizeOptions;
  }

  void showCustomSizeAddDialog() {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              contentPadding: EdgeInsets.all(16),
              title: Text('Add Size'),
              children: [
                TextFormField(
                  controller: myController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Custom Cup Size (ml)',
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                          child: Text('Cancel'),
                          onPressed: closeDialog), // button 1
                      ElevatedButton(
                        child: Text('Save'),
                        onPressed: () {
                          setState(() {
                            saveCustomSize(int.parse(myController.text));
                            myController.clear();
                            closeDialog();
                          });
                        },
                      ), // button 2
                    ])
              ],
            ));
  }

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
                    setState(() {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return SimpleDialog(
                                contentPadding: EdgeInsets.all(16),
                                title: Text('Choose Size'),
                                children: createDialogOptions(context),
                              );
                            });
                          });
                    });
                  }),
            ),
            const Divider(
              height: 40,
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Settings',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),ListTile(
                  title: Text('Weight'),
                  trailing: Text('Todo'),
                ),
                ListTile(
                  title: Text('Gender'),
                  trailing: DropdownButton(
                    value: dropdownValue,
                    items: <DropdownMenuItem>[
                      DropdownMenuItem(
                        value: 'choose',
                        child: Text('Choose'),
                      ),
                      DropdownMenuItem(
                        value: 'male',
                        child: Text('Male'),
                      ),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text('Female'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const Divider(
              height: 40,
              thickness: 1,
              indent: 10,
              endIndent: 10,
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

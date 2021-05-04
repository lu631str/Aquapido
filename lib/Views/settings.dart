import 'package:flutter/material.dart';
import 'package:water_tracker/Persistence/SharedPref.dart';
import 'package:water_tracker/icons/my_flutter_app_icons.dart';
import 'package:numberpicker/numberpicker.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _selectedSize = 300;

  List<int> cupSizes = [100, 200, 300, 330, 400, 500];
  List<Icon> icons = [
    Icon(MyFlutterApp.cup_100ml),
    Icon(MyFlutterApp.cup_200ml),
    Icon(MyFlutterApp.cup_300ml),
    Icon(MyFlutterApp.cup_330ml),
    Icon(MyFlutterApp.cup_400ml),
    Icon(MyFlutterApp.cup_400ml)
  ];

  bool _isPowerBtnAddEnabled = false;
  bool _isShakingAddEnabled = false;
  String _weightUnit = 'kg';
  int _currentWeight = 30;
  int _selectedWeight = 30;
  String _gender = 'choose';
  final myController = TextEditingController(text: '0');

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
    int weight = await loadWeight();
    String gender = await loadGender();
    setState(() {
      this._isPowerBtnAddEnabled = currentCupSize;
      this._isShakingAddEnabled = counter;
      this._selectedWeight = this._currentWeight = weight;

      this._gender = gender;
    });
  }

  void _reset() {
    saveCurrentCupCounter(0);
    saveTotalWater(0);
  }

  void saveCustomSize(customSize) {
    setState(() {
      this.cupSizes.add(customSize);
      this.icons.add(Icon(MyFlutterApp.cup_400ml));
    });
  }

  void closeDialog() {
    Navigator.pop(context);
  }

  List<Widget> createDialogOptions(context) {
    List<Widget> sizeOptions = [];

    // asMap() to get index and item
    cupSizes.asMap().forEach((index, size) {
      return sizeOptions.add(
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, size);
            setState(() {
              this._selectedSize = size;
            });
            saveSize(this._selectedSize);
          },
          child: ListTile(
            title: Text('$size ml'),
            leading: icons[index],
          ),
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
        this._selectedSize = size;
      });
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(
                  'General Settings',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
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
                title: Text('Cup size'),
                trailing: TextButton(
                    child: Text(_selectedSize.toString() + 'ml'),
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
                  ListTile(
                    title: Text(
                      'Personal Settings',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  ListTile(
                    title: Text('Weight'),
                    trailing: TextButton(
                      child:
                          Text(_currentWeight.toString() + ' ' + _weightUnit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return SimpleDialog(
                                    contentPadding: EdgeInsets.all(16),
                                    title: Text('Set Weight'),
                                    children: [
                                      NumberPicker(
                                        value: _selectedWeight,
                                        minValue: 30,
                                        maxValue: 150,
                                        haptics: true,
                                        itemCount: 5,
                                        itemHeight: 32,
                                        textMapper: (numberText) =>
                                            numberText + ' ' + _weightUnit,
                                        onChanged: (value) => setState(
                                            () => _selectedWeight = value),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  _selectedWeight =
                                                      _currentWeight;
                                                  closeDialog();
                                                }), // button 1
                                            ElevatedButton(
                                              child: Text('Save'),
                                              onPressed: () {
                                                saveWeight(_selectedWeight);
                                                _currentWeight =
                                                    _selectedWeight;
                                                closeDialog();
                                              },
                                            ), // button 2
                                          ])
                                    ],
                                  );
                                },
                              );
                            });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Gender'),
                    trailing: DropdownButton(
                      value: _gender,
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
                          saveGender(value);
                          _gender = value;
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
              new Container(
                margin: const EdgeInsets.all(2.0),
                padding: const EdgeInsets.only(
                    top: 3, bottom: 3, left: 100, right: 100),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(
                          6.0) //                 <--- border radius here
                      ),
                ),
                child: OutlinedButton(onPressed: _reset, child: Text('Reset')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

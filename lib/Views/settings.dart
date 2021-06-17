import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:flutter/foundation.dart';

import '../Models/WaterModel.dart';
import '../Utils/Constants.dart';
import '../src/ReminderNotification.dart';
import '../Models/SettingsModel.dart';
import '../Widgets/CupSizeElement.dart';
import '../main.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Map<String, String> _languageCodeMap = {
    'en': 'English',
    'de': 'Deutsch'
  };

  final List<ClockLabel> _clockLabels = [
    ClockLabel.fromTime(time: TimeOfDay(hour: 3, minute: 0), text: '3'),
    ClockLabel.fromTime(time: TimeOfDay(hour: 6, minute: 0), text: '6'),
    ClockLabel.fromTime(time: TimeOfDay(hour: 9, minute: 0), text: '9'),
    ClockLabel.fromTime(time: TimeOfDay(hour: 12, minute: 0), text: '12'),
    ClockLabel.fromTime(time: TimeOfDay(hour: 15, minute: 0), text: '15'),
    ClockLabel.fromTime(time: TimeOfDay(hour: 18, minute: 0), text: '18'),
    ClockLabel.fromTime(time: TimeOfDay(hour: 21, minute: 0), text: '21'),
    ClockLabel.fromTime(time: TimeOfDay(hour: 24, minute: 0), text: '0')
  ];

  final String _weightUnit = 'kg';

  final _myController = TextEditingController(text: '0');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    super.dispose();
  }

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', false);
  }

  void _reset() {
    setData();
    Provider.of<WaterModel>(context, listen: false).removeAllWater();
    Provider.of<SettingsModel>(context, listen: false).resetCustomCups();
    context.read<SettingsModel>().updateDialogSeen(false);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => WaterTrackerApp()));
  }

  void saveCustomSize(customSize, dialogContext) {
    setState(() {
      _myController.text = '0';
      Provider.of<SettingsModel>(context, listen: false)
          .addCustomCupSize(customSize);
      Navigator.pop(dialogContext);
    });
  }

  List<Widget> createCupSizeDialogOptions(
      mainContext, dialogContext, settingstState) {
    List<Widget> sizeOptions = [];

    Provider.of<SettingsModel>(context, listen: true).cupSizes.forEach((size) {
      return sizeOptions.add(
        SimpleDialogOption(
            onPressed: () {
              settingstState.updateCupSize(size);
              Navigator.pop(dialogContext);
            },
            child: CupSizeElement(
              size: size,
              isCustom: !Constants.cupSizes.contains(size),
            )),
      );
    });
    return sizeOptions;
  }

  bool isCustomSizeValid(TextEditingController controller) {
    int customSize = int.tryParse(controller.text) ?? -1;
    if (customSize >= 50 && customSize <= 5000) {
      return true;
    }
    return true;
  }

  void showCustomSizeAddDialog(mainContext) {
    showDialog(
      context: mainContext,
      builder: (dialogContext) => SimpleDialog(
        contentPadding: EdgeInsets.all(16),
        title: const Text('Add Size'),
        children: [
          TextFormField(
            controller: _myController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Custom Cup Size (ml)',
              border: OutlineInputBorder(),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  _myController.text = '0';
                  Navigator.pop(dialogContext);
                }), // button 1
            ElevatedButton(
              child: const Text('Save'),
              onPressed: (isCustomSizeValid(_myController))
                  ? () => saveCustomSize(
                      int.parse(_myController.text), dialogContext)
                  : null,
            ), // button 2
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var settingsState = Provider.of<SettingsModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(
                  'settings.reminder_settings.title',
                  style: Theme.of(context).textTheme.headline5,
                ).tr(),
              ),
              SwitchListTile(
                  value: context.watch<SettingsModel>().reminder,
                  title: Text('settings.reminder_settings.reminder').tr(),
                  onChanged: (value) {
                    setState(() {
                      context.read<SettingsModel>().updateReminder(value);
                      ReminderNotification.updateNotification();
                    });
                  }),
              ListTile(
                title: const Text('settings.reminder_settings.reminderMode').tr(),
                trailing: OutlinedButton(
                  child: RichText(
                    text: TextSpan(children: [
                      WidgetSpan(
                        child: Provider.of<SettingsModel>(context, listen: true).reminderVibration ? Icon(
                          Icons.vibration,
                          size: 20,
                          color: context.watch<SettingsModel>().reminder ? Colors.blue : Colors.black26,
                        ) : Icon(
                          Icons.mobile_off,
                          size: 20,
                          color: context.watch<SettingsModel>().reminder ? Colors.blue : Colors.black26,
                        ),
                      ),
                      TextSpan(text: ' '),
                      WidgetSpan(
                        child: Provider.of<SettingsModel>(context, listen: true).reminderSound ? Icon(
                          Icons.volume_up,
                          size: 20,
                          color: context.watch<SettingsModel>().reminder ? Colors.blue : Colors.black26,
                        ) : Icon(
                          Icons.volume_off,
                          size: 20,
                          color: context.watch<SettingsModel>().reminder ? Colors.blue : Colors.black26,
                        ),
                      )
                    ]),
                  ),
                  onPressed: (context.watch<SettingsModel>().reminder)
                      ? () => showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return SimpleDialog(
                                  contentPadding: const EdgeInsets.all(16),
                                  title: const Text('Set Reminder Mode'),
                                  children: [
                                    ListTile(title: Text('Choose how we should remind you in addition to show a notification'),),
                                    Column(children: [
                                      CheckboxListTile(
                                          value: Provider.of<SettingsModel>(context, listen: true).reminderVibration,
                                          title: Text('Vibration'),
                                          onChanged: (bool value) {
                                            Provider.of<SettingsModel>(context, listen: false).setReminderVibration(value);
                                          }),
                                      CheckboxListTile(
                                          value: Provider.of<SettingsModel>(context, listen: true).reminderSound,
                                          title: Text('Sound'),
                                          onChanged: (bool value) {
                                            Provider.of<SettingsModel>(context, listen: false).setReminderSound(value);
                                          }),
                                    ],),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              context
                                                  .read<SettingsModel>()
                                                  .reset();
                                              Navigator.pop(dialogContext);
                                            }), // button 1
                                        ElevatedButton(
                                          child: const Text('Save'),
                                          onPressed: () {
                                            context
                                                .read<SettingsModel>()
                                                .saveReminderSound();
                                            context
                                                .read<SettingsModel>()
                                                .saveReminderVibration();
                                            ReminderNotification
                                                .updateNotificationChannel();
                                            Navigator.pop(dialogContext);
                                          },
                                        ), // button 2
                                      ],
                                    )
                                  ],
                                );
                              },
                            );
                          })
                      : null,
                ),
              ),
              ListTile(
                title: Text('settings.reminder_settings.sleep_time').tr(),
                trailing: TextButton(
                  child: Text(context
                          .read<SettingsModel>()
                          .startSleepTime
                          .format(context) +
                      ' - ' +
                      context
                          .read<SettingsModel>()
                          .endSleepTime
                          .format(context)),
                  onPressed: (context.watch<SettingsModel>().reminder)
                      ? () async {
                          TimeRange result = await showTimeRangePicker(
                            context: context,
                            labels: this._clockLabels,
                            rotateLabels: false,
                            ticks: 24,
                            ticksLength: 8.0,
                            ticksWidth: 2.0,
                            ticksOffset: 5.0,
                            ticksColor: Colors.black45,
                            start: context.read<SettingsModel>().startSleepTime,
                            end: context.read<SettingsModel>().endSleepTime,
                            use24HourFormat: true,
                          );
                          if (result != null) {
                            context
                                .read<SettingsModel>()
                                .setStartSleepTime(result.startTime);
                            context
                                .read<SettingsModel>()
                                .setEndSleepTime(result.endTime);
                            ReminderNotification.updateNotification();
                          }
                        }
                      : null,
                ),
              ),
              ListTile(
                title:
                    const Text('settings.reminder_settings.reminder_interval')
                        .tr(),
                trailing: TextButton(
                  child: Text(
                      context.watch<SettingsModel>().interval.toString() +
                          ' min'),
                  onPressed: (context.watch<SettingsModel>().reminder)
                      ? () => showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return SimpleDialog(
                                  contentPadding: const EdgeInsets.all(16),
                                  title: const Text('Set Interval'),
                                  children: [
                                    NumberPicker(
                                      value: context
                                          .read<SettingsModel>()
                                          .interval,
                                      minValue: 15,
                                      maxValue: 180,
                                      haptics: true,
                                      itemCount: 5,
                                      itemHeight: 32,
                                      step: 15,
                                      textMapper: (numberText) =>
                                          numberText + ' min',
                                      onChanged: (value) {
                                        setState(() {
                                          context
                                              .read<SettingsModel>()
                                              .setInterval(value);
                                          ReminderNotification
                                              .updateNotification();
                                        });
                                      },
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                context
                                                    .read<SettingsModel>()
                                                    .reset();
                                                Navigator.pop(dialogContext);
                                              }), // button 1
                                          ElevatedButton(
                                            child: const Text('Save'),
                                            onPressed: () {
                                              context
                                                  .read<SettingsModel>()
                                                  .saveInterval();
                                              ReminderNotification
                                                  .updateNotification();
                                              Navigator.pop(dialogContext);
                                            },
                                          ), // button 2
                                        ])
                                  ],
                                );
                              },
                            );
                          })
                      : null,
                ),
              ),
              ListTile(
                title: Text('settings.reminder_settings.cup_size').tr(),
                trailing: TextButton(
                    child: Text(
                        context.watch<SettingsModel>().cupSize.toString() +
                            ' ml'),
                    onPressed: () {
                      setState(() {
                        showDialog(
                          context: context,
                          builder: (dialogContext) =>
                              ChangeNotifierProvider<SettingsModel>.value(
                            value: settingsState,
                            child: SimpleDialog(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text('Choose Size'),
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: Scrollbar(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: createCupSizeDialogOptions(
                                            context,
                                            dialogContext,
                                            settingsState),
                                      ),
                                    ),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      showCustomSizeAddDialog(context);
                                    });
                                  },
                                  child: const Text('Add'),
                                )
                              ],
                            ),
                          ),
                        );
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
                      'settings.quick_settings.title',
                      style: Theme.of(context).textTheme.headline5,
                    ).tr(),
                  ),
                  SwitchListTile(
                      value: context.watch<SettingsModel>().powerSettings,
                      title: Text('settings.quick_settings.quick_power').tr(),
                      onChanged: (value) {
                        setState(() {
                          context
                              .read<SettingsModel>()
                              .updatePowerSettings(value);
                        });
                      }),
                  SwitchListTile(
                      value: context.watch<SettingsModel>().shakeSettings,
                      title: Text('settings.quick_settings.quick_shaking').tr(),
                      onChanged: (value) {
                        setState(() {
                          context
                              .read<SettingsModel>()
                              .updateShakeSettings(value);
                        });
                      }),
                  SwitchListTile(
                      value: false,
                      title:
                          Text('settings.quick_settings.quick_gesture').tr()),
                ],
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
                      'settings.personal_settings.title',
                      style: Theme.of(context).textTheme.headline5,
                    ).tr(),
                  ),
                  ListTile(
                    title: Text('settings.personal_settings.weight').tr(),
                    trailing: TextButton(
                      child: Text(
                          context.watch<SettingsModel>().weight.toString() +
                              ' ' +
                              _weightUnit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return SimpleDialog(
                                    contentPadding: EdgeInsets.all(16),
                                    title: Text('Set Weight'),
                                    children: [
                                      NumberPicker(
                                          value: context
                                              .read<SettingsModel>()
                                              .weight,
                                          minValue: 40,
                                          maxValue: 150,
                                          haptics: true,
                                          itemCount: 5,
                                          itemHeight: 32,
                                          textMapper: (numberText) =>
                                              numberText + ' ' + _weightUnit,
                                          onChanged: (value) => setState(() =>
                                              context
                                                  .read<SettingsModel>()
                                                  .setWeight(value))),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  context
                                                      .read<SettingsModel>()
                                                      .reset();
                                                  Navigator.pop(dialogContext);
                                                }), // button 1
                                            ElevatedButton(
                                              child: Text('Save'),
                                              onPressed: () {
                                                context
                                                    .read<SettingsModel>()
                                                    .saveWeight();
                                                Navigator.pop(dialogContext);
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
                    title: Text('settings.personal_settings.gender').tr(),
                    trailing: DropdownButton(
                      value: context.watch<SettingsModel>().gender,
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
                          context.read<SettingsModel>().updateGender(value);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('settings.personal_settings.language').tr(),
                    trailing: DropdownButton<Locale>(
                      value: context.supportedLocales.firstWhere((langLocale) =>
                          langLocale.languageCode ==
                          Provider.of<SettingsModel>(context, listen: false)
                              .language),
                      items: context.supportedLocales
                          .map<DropdownMenuItem<Locale>>((Locale langLocale) {
                        return DropdownMenuItem<Locale>(
                          value: langLocale,
                          child:
                              Text(_languageCodeMap[langLocale.languageCode]),
                        );
                      }).toList(),
                      onChanged: (langLocale) {
                        context.setLocale(langLocale);
                        print(langLocale.languageCode);
                        context
                            .read<SettingsModel>()
                            .updateLanguage(langLocale.languageCode);
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
                margin: const EdgeInsets.only(top: 2, bottom: 20),
                padding: const EdgeInsets.only(
                    top: 3, bottom: 3, left: 100, right: 100),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(
                          6.0) //                 <--- border radius here
                      ),
                ),
                child: OutlinedButton(
                    onPressed: () => {
                          showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return SimpleDialog(
                                      contentPadding: EdgeInsets.all(16),
                                      title: Text('Reset - Are you sure?'),
                                      children: [
                                        Text(
                                            'This action can NOT be undone. All data will be lost!'),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        dialogContext);
                                                  }), // button 1
                                              ElevatedButton(
                                                child: const Text('Reset'),
                                                onPressed: () {
                                                  this._reset();
                                                  Navigator.pop(dialogContext);
                                                },
                                              ), // button 2
                                            ])
                                      ],
                                    );
                                  },
                                );
                              })
                        },
                    child: const Text('Reset')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

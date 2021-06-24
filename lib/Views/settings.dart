import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:flutter/foundation.dart';

import '../Models/WaterModel.dart';
import '../src/ReminderNotification.dart';
import '../Models/SettingsModel.dart';
import '../main.dart';
import '../Widgets/settings/QuickAddDialogInfo.dart';

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

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', false);
  }

  void _reset() {
    setData();
    Provider.of<WaterModel>(context, listen: false).removeAllWater();
    Provider.of<SettingsModel>(context, listen: false).resetCustomCups();
    context.read<SettingsModel>().updateDialogSeen(false);
    context.read<SettingsModel>().updateIntroSeen(false);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => WaterTrackerApp()));
  }

  @override
  Widget build(BuildContext context) {
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
                title:
                    const Text('settings.reminder_settings.reminderMode').tr(),
                trailing: OutlinedButton(
                  child: RichText(
                    text: TextSpan(children: [
                      WidgetSpan(
                        child: Provider.of<SettingsModel>(context, listen: true)
                                .reminderVibration
                            ? Icon(
                                Icons.vibration,
                                size: 20,
                                color: context.watch<SettingsModel>().reminder
                                    ? Colors.blue
                                    : Colors.black26,
                              )
                            : Icon(
                                Icons.mobile_off,
                                size: 20,
                                color: context.watch<SettingsModel>().reminder
                                    ? Colors.blue
                                    : Colors.black26,
                              ),
                      ),
                      TextSpan(text: ' '),
                      WidgetSpan(
                        child: Provider.of<SettingsModel>(context, listen: true)
                                .reminderSound
                            ? Icon(
                                Icons.volume_up,
                                size: 20,
                                color: context.watch<SettingsModel>().reminder
                                    ? Colors.blue
                                    : Colors.black26,
                              )
                            : Icon(
                                Icons.volume_off,
                                size: 20,
                                color: context.watch<SettingsModel>().reminder
                                    ? Colors.blue
                                    : Colors.black26,
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
                                  title: const Text('settings.reminder_mode_dialog.title').tr(),
                                  children: [
                                    ListTile(
                                      title: Text(
                                          'settings.reminder_mode_dialog.content').tr(),
                                    ),
                                    Column(
                                      children: [
                                        CheckboxListTile(
                                            value: Provider.of<SettingsModel>(
                                                    context,
                                                    listen: true)
                                                .reminderVibration,
                                            title: Text('settings.reminder_mode_dialog.vibration').tr(),
                                            onChanged: (bool value) {
                                              Provider.of<SettingsModel>(
                                                      context,
                                                      listen: false)
                                                  .setReminderVibration(value);
                                            }),
                                        CheckboxListTile(
                                            value: Provider.of<SettingsModel>(
                                                    context,
                                                    listen: true)
                                                .reminderSound,
                                            title: Text('settings.reminder_mode_dialog.sound').tr(),
                                            onChanged: (bool value) {
                                              Provider.of<SettingsModel>(
                                                      context,
                                                      listen: false)
                                                  .setReminderSound(value);
                                            }),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        TextButton(
                                            child: const Text('dialog.cancel').tr(),
                                            onPressed: () {
                                              context
                                                  .read<SettingsModel>()
                                                  .reset();
                                              Navigator.pop(dialogContext);
                                            }), // button 1
                                        ElevatedButton(
                                          child: const Text('dialog.save').tr(),
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
                                  title: const Text('settings.reminder_interval_dialog.title').tr(),
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
                                              child: const Text('dialog.cancel').tr(),
                                              onPressed: () {
                                                context
                                                    .read<SettingsModel>()
                                                    .reset();
                                                Navigator.pop(dialogContext);
                                              }), // button 1
                                          ElevatedButton(
                                            child: const Text('dialog.save').tr(),
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
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return QuickAddDialogInfo();
                              });
                            });
                      },
                      icon: Icon(Icons.info_outline),
                      padding: const EdgeInsets.only(right: 6),
                      constraints: BoxConstraints(),
                    ),
                  ),
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
                                    title: Text('settings.weight.title').tr(),
                                    children: [
                                      NumberPicker(
                                          value: context
                                              .read<SettingsModel>()
                                              .weight,
                                          minValue: 35,
                                          maxValue: 180,
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
                                                child: Text('dialog.cancel').tr(),
                                                onPressed: () {
                                                  context
                                                      .read<SettingsModel>()
                                                      .reset();
                                                  Navigator.pop(dialogContext);
                                                }), // button 1
                                            ElevatedButton(
                                              child: Text('dialog.save').tr(),
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
                    title: Text('settings.personal_settings.activity').tr(),
                    trailing: DropdownButton(
                      value: context.watch<SettingsModel>().activity,
                      items: <DropdownMenuItem>[
                        DropdownMenuItem(
                          value: 'low',
                          child: Text('settings.activity.low').tr(),
                        ),
                        DropdownMenuItem(
                          value: 'normal',
                          child: Text('settings.activity.normal').tr(),
                        ),
                        DropdownMenuItem(
                          value: 'high',
                          child: Text('settings.activity.high').tr(),
                        ),
                        DropdownMenuItem(
                          value: 'very_high',
                          child: Text('settings.activity.very_high').tr(),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          context.read<SettingsModel>().updateActivity(value);
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
                          child: Text('settings.gender.choose').tr(),
                        ),
                        DropdownMenuItem(
                          value: 'male',
                          child: Text('settings.gender.male').tr(),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('settings.gender.female').tr(),
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
              Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                      child: const Text('dialog.reset').tr(),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                      ),
                      onPressed: () => {
                        showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return SimpleDialog(
                                    contentPadding: EdgeInsets.all(16),
                                    title: Text('settings.reset_dialog.title').tr(),
                                    children: [
                                      Text(
                                          'settings.reset_dialog.content').tr(),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            TextButton(
                                                child: Text('dialog.cancel').tr(),
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
                                                }), // button 1
                                            ElevatedButton(
                                              child: const Text('dialog.reset').tr(),
                                              onPressed: () {
                                                Navigator.pop(dialogContext);
                                                this._reset();
                                              },
                                            ), // button 2
                                          ])
                                    ],
                                  );
                                },
                              );
                            })
                      },
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Utils/utils.dart';
import '../Models/SettingsModel.dart';

class ReminderNotification {
  static NotificationChannel _getNotificationChannel(
      bool playSound, bool enableVibration) {
    return NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
        playSound: playSound,
        soundSource: 'resource://raw/res_bonez_water_reminder',
        enableVibration: enableVibration);
  }

  static void initialize() {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon

        'resource://drawable/notification_icon_done',
        [
          _getNotificationChannel(false, true),
        ]);
  }

  static void checkPermission(BuildContext context) {
    bool permissionDialogSeen = Provider.of<SettingsModel>(context, listen: false).permissionNote;
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed && !permissionDialogSeen) {
        showDialog(
            context: context,
            builder: (dialogContext) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return SimpleDialog(
                    contentPadding: const EdgeInsets.all(16),
                    title: const Text('notification_permission.title').tr(),
                    children: [
                      Text(
                          'notification_permission.body').tr(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('notification_permission.button').tr(),
                            onPressed: () {
                              Provider.of<SettingsModel>(context, listen: false).updatePermissionNoteSeen(true);
                              Navigator.pop(dialogContext);
                              AwesomeNotifications()
                                  .requestPermissionToSendNotifications();
                            },
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            });
      }
    });
  }

  static void updateNotificationChannel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool reminderSound = prefs.getBool('reminderSound') ?? false;
    bool reminderVibration = prefs.getBool('reminderVibration') ?? true;

    AwesomeNotifications().setChannel(
        _getNotificationChannel(reminderSound, reminderVibration),
        forceUpdate: true);
  }

  static void updateNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await AwesomeNotifications().cancelAllSchedules();
    bool isReminderActive = prefs.getBool('reminder') ?? false;

    if (!isReminderActive) {
      log('ReminderNotification: turned off');
      return;
    }
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    int interval = prefs.getInt('interval') ?? 60;
    int startTimeHours = prefs.getInt('startTimeHours') ?? 20;
    int startTimeMinutes = prefs.getInt('startTimeMinutes') ?? 0;
    int endTimeHours = prefs.getInt('endTimeHours') ?? 8;
    int endTimeMinutes = prefs.getInt('endTimeMinutes') ?? 0;
    int cupSize = prefs.getInt('size') ?? 300;

    if (isCurrentTimeOfDayOutsideTimes(
        TimeOfDay.now(),
        TimeOfDay(hour: startTimeHours, minute: startTimeMinutes),
        TimeOfDay(hour: endTimeHours, minute: endTimeMinutes))) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Stay Hydrated!',
              body: 'notification.body'.tr(),
              payload: {'cupSize': '$cupSize'},),
          schedule: NotificationInterval(
              interval: interval, timeZone: localTimeZone, repeats: true));
      log('ReminderNotification: scheduled');
    }
  }
}

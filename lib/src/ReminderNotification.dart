import 'package:flutter/material.dart';
import '../Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';

class ReminderNotification {

  static NotificationChannel _getNotificationChannel(bool playSound, bool enableVibration) {
    return NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: playSound,
        soundSource: 'resource://raw/res_bonez_water_reminder',
        enableVibration: enableVibration);
  }

  static void initialize() {

    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          _getNotificationChannel(false, true),
        ]);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Todo: Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static void updateNotificationChannel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool reminderSound = prefs.getBool('reminderSound') ?? false;
    bool reminderVibration = prefs.getBool('reminderVibration') ?? true;

    AwesomeNotifications().setChannel(_getNotificationChannel(reminderSound, reminderVibration), forceUpdate: true);
  }

  static void updateNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await AwesomeNotifications().cancelAllSchedules();
    bool isReminderActive = prefs.getBool('reminder') ?? false;

    if(!isReminderActive) {
      log('ReminderNotification: turned off');
      return;
    }
    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    int interval = prefs.getInt('interval') ?? 60;
    int startTimeHours = prefs.getInt('startTimeHours') ?? 20;
    int startTimeMinutes = prefs.getInt('startTimeMinutes') ?? 0;
    int endTimeHours = prefs.getInt('endTimeHours') ?? 8;
    int endTimeMinutes = prefs.getInt('endTimeMinutes') ?? 0;

    if (isCurrentTimeOfDayOutsideTimes(
        TimeOfDay.now(),
        TimeOfDay(hour: startTimeHours, minute: startTimeMinutes),
        TimeOfDay(hour: endTimeHours, minute: endTimeMinutes))) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Stay Hydrated - Drink water now',
              body: 'Don\'t forget to drink water!'),
          actionButtons: [
            NotificationActionButton(
                enabled: true,
                key: 'myButton',
                label: 'Add Water - ${prefs.getInt('size') ?? 300}ml',
                buttonType: ActionButtonType.Default)
          ],
      schedule: NotificationInterval(interval: interval, timeZone: localTimeZone, repeats: true));
      log('ReminderNotification: scheduled');
    }
  }

}

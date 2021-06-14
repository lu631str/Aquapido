import 'package:flutter/material.dart';
import '../Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class ReminderNotification {
  static void initialize() {
    FlutterBackgroundService.initialize(_onStart, foreground: false);

    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white,
              enableVibration: true,
              vibrationPattern: lowVibrationPattern)
        ]);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Todo: Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static void updateSleepTime(TimeOfDay startTime, TimeOfDay endTime) {
    FlutterBackgroundService().sendData({
      "action": "setSleepTime",
      "startTimeHours": startTime.hour,
      "startTimeMinutes": startTime.minute,
      "endTimeHours": endTime.hour,
      "endTimeMinutes": endTime.minute,
    });
    _restartReminder();
  }

  static void updateReminderInterval(int interval) {
    FlutterBackgroundService()
        .sendData({"action": "setInterval", "interval": interval});
    _restartReminder();
  }

  static void _restartReminder() {
    FlutterBackgroundService().sendData({"action": "startReminder"});
  }
}

void _onStart() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final service = FlutterBackgroundService();
    Timer timer;
    int interval = prefs.getInt('interval') ?? 60;
    int startTimeHours = prefs.getInt('startTimeHours') ?? 20;
    int startTimeMinutes = prefs.getInt('startTimeMinutes') ?? 0;
    int endTimeHours = prefs.getInt('endTimeHours') ?? 8;
    int endTimeMinutes = prefs.getInt('endTimeMinutes') ?? 0;
    service.onDataReceived.listen((event) async {
      if (event["action"] == "setAsForeground") {
        service.setForegroundMode(true);
        return;
      }

      if (event["action"] == "setAsBackground") {
        service.setForegroundMode(false);
      }

      if (event["action"] == "stopService") {
        service.stopBackgroundService();
      }

      if (event["action"] == "setInterval") {
        interval = int.parse(event["interval"].toString());
      }

      if (event["action"] == "setSleepTime") {
        startTimeHours = int.parse(event["startTimeHours"].toString());
        startTimeMinutes = int.parse(event["startTimeMinutes"].toString());
        endTimeHours = int.parse(event["endTimeHours"].toString());
        endTimeMinutes = int.parse(event["endTimeMinutes"].toString());
      }

      if (event["action"] == "startReminder") {
        if (timer != null && timer.isActive) {
          timer.cancel();
        }
        debugPrint('StartRminder');
        timer = Timer.periodic(Duration(seconds: interval), (timer) async {
          if (!(await service.isServiceRunning())) timer.cancel();

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
                ]);
          }
        });
      }
    });
  }
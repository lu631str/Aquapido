import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Views/goals.dart';
import 'Views/settings.dart';
import 'Utils/utils.dart';
import 'Views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/Views/goals.dart';
import 'package:water_tracker/Views/introductionScreen.dart';
import 'package:water_tracker/Views/settings.dart';
import 'package:water_tracker/Views/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Views/statistics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'Models/SettingsModel.dart';
import 'Models/WaterModel.dart';
import 'Persistence/Database.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'dart:async';

SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService.initialize(onStart, foreground: false);
  await EasyLocalization.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  DatabaseHelper.database = await DatabaseHelper().initDatabaseConnection();

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
            vibrationPattern: lowVibrationPattern)
      ]);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('de', 'DE')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en', 'US'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsModel()),
          ChangeNotifierProvider(create: (_) => WaterModel()),
        ],
        child: WaterTrackerApp(),
      ),
    ),
  );
}

void onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
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

    if (event["action"] == "sleepTime") {
      startTimeHours = int.parse(event["startTimeHours"].toString());
      startTimeMinutes = int.parse(event["startTimeMinutes"].toString());
      endTimeHours = int.parse(event["endTimeHours"].toString());
      endTimeMinutes = int.parse(event["endTimeMinutes"].toString());
    }

    if (event["action"] == "startReminder") {
      debugPrint("called");
      debugPrint("get prefs");
      if(timer != null && timer.isActive) {
        timer.cancel();
        debugPrint("timer canceled");
      }
      debugPrint("startTimer");
      timer = Timer.periodic(Duration(seconds: interval),
          (timer) async {
        if (!(await service.isServiceRunning())) timer.cancel();

        if (!isCurrentTimeOfDayInBetweenTimes(
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

class WaterTrackerApp extends StatelessWidget {
  final int currentChild;
  bool introSeen;

  WaterTrackerApp({Key key, this.currentChild, this.introSeen})
      : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child),
        title: 'Quick Water Tracker',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.comfortaa().fontFamily,

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
            headline2: TextStyle(fontSize: 42.0),
            headline3: TextStyle(fontSize: 32.0),
            headline4: TextStyle(fontSize: 24.0),
            bodyText2: TextStyle(fontSize: 14.0),
          ),
        ),
        home:
            (introSeen != true) ? Splash() : Main(currentChild: currentChild));
  }
}

class Splash extends StatefulWidget {
  const Splash({
    Key key,
  }) : super(key: key);

  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  SplashState({
    Key key,
  });

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      return Main.id;
    } else {
      // Set the flag to true at the end of onboarding screen if everything is successfull and so I am commenting it out
      //await prefs.setBool('seen', true);
      return IntroScreen.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkFirstSeen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
                fontFamily: GoogleFonts.comfortaa().fontFamily,

                // Define the default TextTheme. Use this to specify the default
                // text styling for headlines, titles, bodies of text, and more.
                textTheme: TextTheme(
                  headline1:
                      TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                  headline2: TextStyle(fontSize: 42.0),
                  headline3: TextStyle(fontSize: 32.0),
                  headline4: TextStyle(fontSize: 24.0),
                  bodyText2: TextStyle(fontSize: 14.0),
                ),
              ),
              initialRoute: snapshot.data,
              routes: {
                IntroScreen.id: (context) => IntroScreen(),
                Main.id: (context) => Main(),
              },
            );
          }
        });
  }
}

class Main extends StatefulWidget {
  Main({Key key, this.title, this.currentChild}) : super(key: key);
  static String id = 'MainScreen';

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final int currentChild;

  @override
  _MainState createState() => _MainState(currentChild: currentChild);
}

class _MainState extends State<Main> {
  final int currentChild;
  int _currentIndex = 0;

  _MainState({this.currentChild}) {
    _currentIndex = (currentChild == null) ? 0 : currentChild;
  }

  List<Widget> _children = [
    Home(),
    Statistics(),
    Goals(),
    Settings(),
  ];

  // int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const color1 = const Color(0xff91ceff);
    const color2 = const Color(0xfffafdff);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    //
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[color1, color2],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 30,
          title: const Text('Aquapido - Quick Water Tracker'),
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'home.title'.tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.timeline),
                label: 'statistics.title'.tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'goals.title'.tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'settings.title'.tr(),
              ),
            ],
            selectedItemColor: Colors.white,
            backgroundColor: Colors.blue,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

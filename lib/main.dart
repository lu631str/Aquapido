import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/src/Models/DailyGoalModel.dart';

import 'Views/goals.dart';
import 'Views/settings.dart';
import 'Views/home.dart';
import 'Views/Onbording.dart';
import 'Views/statistics.dart';
import 'src/Models/SettingsModel.dart';
import 'src/Models/WaterModel.dart';
import 'src/Persistence/Database.dart';
import 'src/ReminderNotification.dart';

SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  DatabaseHelper.database = await DatabaseHelper().initDatabaseConnection();
  ReminderNotification.initialize(prefs.getBool('reminderSound') ?? false,
      prefs.getBool('reminderVibration') ?? true);

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('de', 'DE')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsModel()),
          ChangeNotifierProvider(create: (_) => WaterModel()),
          ChangeNotifierProvider(create: (_) => DailyGoalModel()),
        ],
        child: WaterTrackerApp(),
      ),
    ),
  );
}

class WaterTrackerApp extends StatelessWidget {
  final int currentChild;
  WaterTrackerApp({Key key, this.currentChild});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Quick Water Tracker',
        theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.lightBlueAccent,
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.comfortaa().fontFamily,
          cardColor: Color(0xFFEAF7FF),
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
            headline2: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            headline3: TextStyle(fontSize: 32.0),
            headline4: TextStyle(fontSize: 24.0),
            bodyText2: TextStyle(fontSize: 14.0),
          ),
        ),
        home: Main(currentChild: currentChild));
  }
}

class Main extends StatefulWidget {
  Main({Key key, this.title, this.currentChild}) : super(key: key);

  final String title;
  final int currentChild;
  static String id = 'MainScreen';

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

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: (!Provider.of<SettingsModel>(context, listen: false).introSeen)
          ? Onbording()
          : Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                toolbarHeight: 0.0,
              ),
              body: _children[_currentIndex],
              bottomNavigationBar: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      tileMode: TileMode.clamp,
                      colors: [
                        Colors.blue,
                        Colors.lightBlueAccent,
                      ],
                    ),
                  ),
                  child: BottomNavigationBar(
                    elevation: 0,
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
                    backgroundColor: Colors.transparent,
                    onTap: _onItemTapped,
                  ),
                ),
              ),
            ),
    );
  }
}

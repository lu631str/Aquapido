import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/Views/goals.dart';
import '/Views/settings.dart';
import '/Views/home.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Views/statistics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '/Models/SettingsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/Models/WaterModel.dart';



SharedPreferences prefs; // Praeferenzen festlegen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

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
    ),),
  );
}

class WaterTrackerApp extends StatelessWidget {
  final int currentChild;

  WaterTrackerApp({this.currentChild});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        builder: (context, child) =>
          MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
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
        home: Main(currentChild: currentChild,));
  }
}

class Main extends StatefulWidget {
  Main({Key key, this.title, this.currentChild}) : super(key: key);

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
        bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}

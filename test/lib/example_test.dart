import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:water_tracker/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Devices.dart';

void main() {
  Map<String, dynamic> sharedPrefMock = {
    'size': 300,
    'counter': 0,
    'shake': false,
    'power': false,
    'weight': 40,
    'gender': 'choose',
    'language': 'en',
  };

  Widget makeTestableWidget(Widget child) {
    return MediaQuery(
      data: MediaQueryData(),
      child: EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('de', 'DE')],
        path:
            '../../assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'US'),
        child: MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en', 'US')],
          locale: Locale('en', 'US'),
          home: child,
        )));
  }

  group('Home Screens', () {
    testGoldens('testStatistics', (tester) async {
      // Prepare
      SharedPreferences.setMockInitialValues(sharedPrefMock);
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
      await loadAppFonts();

      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(
          devices: devicesWithDifferentTextScales,
        )
        ..addScenario(widget: makeTestableWidget(WaterTrackerApp(currentChild: 1)));
      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'statistics');
    });

    testGoldens('testGoals', (tester) async {
      // Prepare
      SharedPreferences.setMockInitialValues(sharedPrefMock);
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
      await loadAppFonts();

      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(
          devices: devicesWithDifferentTextScales,
        )
        ..addScenario(widget: makeTestableWidget(WaterTrackerApp(currentChild: 2)));
      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'goals');
    });

    testGoldens('testSettings', (tester) async {
      // Prepare
      SharedPreferences.setMockInitialValues(sharedPrefMock);
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
      await loadAppFonts();

      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(
          devices: devicesWithDifferentTextScales,
        )
        ..addScenario(widget: makeTestableWidget(WaterTrackerApp(currentChild: 3)));
      await tester.pumpDeviceBuilder(builder);
      await tester.pumpAndSettle();
      await screenMatchesGolden(tester, 'settings');
    });
  });
}

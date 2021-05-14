import 'dart:async';

import 'package:golden_toolkit/golden_toolkit.dart';


Future<void> testExecutable(FutureOr<void> Function() testMain) async {
   await loadAppFonts();
   return testMain();
   }



testGoldens('example test', (tester) async {
 final builder = DeviceBuilder()
 ..overrideDevicesForAllScenarios(devices: [Device.phone,
 ])
 ..addScenario(widget: MyApp());
 await tester.pumpDeviceBuilder(builder);
 await screenMatchesGolden(tester, 'initial');
 });
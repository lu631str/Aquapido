
import 'package:flutter/widgets.dart';
import 'package:water_tracker/main.dart';
import 'dart:async';

import 'package:golden_toolkit/golden_toolkit.dart';

group('MultiFrameImageStreamCompleter', () )  {

testGoldens('example test', (tester) async {
final builder = DeviceBuilder()
..overrideDevicesForAllScenarios(devices: [
Device.phone,
])
..addScenario(widget: MyApp());
await tester.pumpDeviceBuilder(builder);
await screenMatchesGolden(tester, 'initial');
});




}

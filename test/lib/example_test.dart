import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:water_tracker/Views/statistics.dart';

import 'Devices.dart';

void main() {
  testGoldens('testGoldens', (tester) async {
    await loadAppFonts();
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: 
        devicesWithDifferentTextScales,
      )
      ..addScenario(widget: Statistics());
    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'initial');
  });
}

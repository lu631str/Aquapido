import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';

import '../Widgets/statistics/Chart.dart';
import '../Widgets/statistics/AverageCard.dart';
import '../Models/WaterModel.dart';
import '../Models/SettingsModel.dart';

class Statistics extends StatefulWidget {
  Statistics({Key key, this.title});

  final String title;

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool isDayDiagram = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate:
            Provider.of<SettingsModel>(context, listen: false).selectedDate,
        firstDate: DateTime.parse("2020-01-01 12:00:00"),
        lastDate: DateTime.now());
    if (picked != null &&
        picked !=
            Provider.of<SettingsModel>(context, listen: false).selectedDate) {
      setState(() {
        Provider.of<SettingsModel>(context, listen: false)
            .setSelectedDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AverageCard(
                    subTitle: 'Liters / Day',
                    isMl: true,
                    futureValue: Provider.of<WaterModel>(context, listen: false)
                        .getAverageLitersPerDay()),
                AverageCard(
                    subTitle: 'Liters / Week',
                    isMl: true,
                    futureValue: Provider.of<WaterModel>(context, listen: false)
                        .getAverageLitersPerWeek()),
                AverageCard(
                    subTitle: 'Cups / Day',
                    isMl: false,
                    futureValue: Provider.of<WaterModel>(context, listen: false)
                        .getAverageCupsPerDay()),
              ],
            ),
            TextButton(
                child: Text(
                    '${DateFormat('dd.MM.yy').format(Provider.of<SettingsModel>(context, listen: false).selectedDate)}'),
                onPressed: () => _selectDate(context)),
            Card(
              elevation: 4,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text('Total Liters per Day: 3.4L'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: ToggleSwitch(
                          minHeight: 24.0,
                          minWidth: 60.0,
                          cornerRadius: 14.0,
                          activeBgColors: [
                            [Color(0xFF91BBFB)],
                            [Color(0xFF91BBFB)]
                          ],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Color(0xFFb5b5b5),
                          inactiveFgColor: Colors.white,
                          initialLabelIndex:
                              Provider.of<SettingsModel>(context, listen: true)
                                      .dayDiagramm
                                  ? 0
                                  : 1,
                          totalSwitches: 2,
                          labels: ['Day', 'Week'],
                          radiusStyle: true,
                          onToggle: (index) {
                            Provider.of<SettingsModel>(context, listen: false)
                                .setDayDiagramm(index == 0);
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    child: Chart(),
                    padding: EdgeInsets.all(5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

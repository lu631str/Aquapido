import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:water_tracker/Widgets/statistics/Calendar.dart';

import '../Utils/Constants.dart';
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

  Widget _getStringForDiagramm() {
    DateTime startDate = Provider.of<SettingsModel>(context, listen: false).selectedDate;
    if(Provider.of<SettingsModel>(context, listen: true).dayDiagramm) {
      return Text('statistics.chart.header'.tr() + ' ${Provider.of<WaterModel>(context, listen: false).totalWaterAmountPerDay(startDate) / 1000.0}L');
    } else {
      return Text('statistics.chart.header'.tr() + ' ${Provider.of<WaterModel>(context, listen: false).getWaterListFor7Days(startDate).reduce((a, b) => a + b) / 1000.0}L');
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
                    subTitle: 'statistics.stats_1'.tr(),
                    isMl: true,
                    futureValue: Provider.of<WaterModel>(context, listen: false)
                        .getAverageLitersPerDay()),
                AverageCard(
                    subTitle: 'statistics.stats_2'.tr(),
                    isMl: true,
                    futureValue: Provider.of<WaterModel>(context, listen: false)
                        .getAverageLitersPerWeek()),
                AverageCard(
                    subTitle: 'statistics.stats_3'.tr(),
                    isMl: false,
                    futureValue: Provider.of<WaterModel>(context, listen: false)
                        .getAverageCupsPerDay()),
              ],
            ),
            Container(
            child:Calendar()),
              // TextButton(
                // Text(
                //     '${DateFormat('dd.MM.yy').format(Provider.of<SettingsModel>(context, listen: false).selectedDate)}'),
                // onPressed: () => _selectDate(context)),
            Card(
              elevation: Constants.CARD_ELEVATION,
              margin: Constants.CARD_MARGIN,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 9),
                        child: _getStringForDiagramm(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 9, right: 9),
                        child: ToggleSwitch(
                          minHeight: 28.0,
                          minWidth: 68.0,
                          cornerRadius: 14.0,
                          activeBgColors: [
                            [Theme.of(context).primaryColor],
                            [Theme.of(context).primaryColor]
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
                          labels: [tr('statistics.chart.switch_day'), tr('statistics.chart.switch_week')],
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

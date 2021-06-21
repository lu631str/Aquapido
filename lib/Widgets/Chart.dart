import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/Water.dart';
import '../Models/WaterModel.dart';
import '../Models/SettingsModel.dart';
import '../Widgets/WeeklyBarChart.dart';
import '../Widgets/DailyLineChart.dart';

class Chart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChartState();
}

class ChartState extends State<Chart> {
  List<double> waterListWeek;
  List<Water> waterListDay;
  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate =
        Provider.of<SettingsModel>(context, listen: false).selectedDate;
    waterListWeek = Provider.of<WaterModel>(context, listen: false)
        .getWaterListFor7Days(selectedDate);
    waterListDay = Provider.of<WaterModel>(context, listen: false)
        .getWaterListForDay(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.9,
      child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: const Color(0xff3546a6),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 24, bottom: 12),
              child:
                  Provider.of<SettingsModel>(context, listen: true).dayDiagramm
                      ? DailyLineChart(waterListDay)
                      : WeeklyBarChart(waterListWeek, selectedDate),
            ),
          )),
    );
  }
}

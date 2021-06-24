import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/Water.dart';
import '../../Models/WaterModel.dart';
import '../../Models/SettingsModel.dart';
import 'WeeklyBarChart.dart';
import 'DailyLineChart.dart';

class Chart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChartState();
}

class ChartState extends State<Chart> {
  List<double> waterListWeek;
  List<Water> waterListDay;
  DateTime selectedDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    selectedDate =
        Provider.of<SettingsModel>(context, listen: true).selectedDate;
    waterListWeek = Provider.of<WaterModel>(context, listen: true)
        .getWaterListFor7Days(selectedDate);
    waterListDay = Provider.of<WaterModel>(context, listen: true)
        .getWaterListForDay(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Container(
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                tileMode: TileMode.clamp,
                                colors: [
                                  Colors.blue,
                                  Colors.lightBlueAccent,
                                ],
                              ),),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.transparent,
          elevation: 0,
          child: Provider.of<SettingsModel>(context, listen: true).dayDiagramm
              ? DailyLineChart(waterListDay)
              : WeeklyBarChart(waterListWeek, selectedDate)),
    ),
      ); 
  }
}

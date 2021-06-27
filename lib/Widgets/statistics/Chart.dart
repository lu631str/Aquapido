import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../src/Models/SettingsModel.dart';
import 'WeeklyBarChart.dart';
import 'DailyLineChart.dart';

class Chart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChartState();
}

class ChartState extends State<Chart> {
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
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ],
          ),
        ),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.transparent,
            elevation: 0,
            child: Provider.of<SettingsModel>(context, listen: true).dayDiagramm
                ? DailyLineChart()
                : WeeklyBarChart()),
      ),
    );
  }
}

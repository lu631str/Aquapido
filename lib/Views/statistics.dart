import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/BarChartWidget.dart';

import '../Widgets/AverageCard.dart';
import '../Models/WaterModel.dart';

class Statistics extends StatefulWidget {
  Statistics({Key key, this.title});

  final String title;

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(child: 
        AspectRatio(
          aspectRatio: 100 / 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AverageCard(
                      subTitle: 'Liters / Day',
                      isMl: true,
                      futureValue:
                          Provider.of<WaterModel>(context, listen: false)
                              .getAverageLitersPerDay()),
                  AverageCard(
                      subTitle: 'Liters / Week',
                      isMl: true,
                      futureValue:
                          Provider.of<WaterModel>(context, listen: false)
                              .getAverageLitersPerWeek()),
                  AverageCard(
                      subTitle: 'Cups / Day',
                      isMl: false,
                      futureValue:
                          Provider.of<WaterModel>(context, listen: false)
                              .getAverageCupsPerDay()),
                ],
              ),
              Expanded(child: BarChartSample1()),
              
            ],
          ),
        ),),

    );
  }
}

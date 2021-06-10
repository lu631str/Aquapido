import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:water_tracker/Widgets/AverageCard.dart';
import '../Persistence/Database.dart';
import 'package:provider/provider.dart';
import '../Models/WaterModel.dart';

class Statistics extends StatefulWidget {
  Statistics({Key key, this.title}) {
     getAverageCupsPerDay();
  }

  final String title;

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: new AspectRatio(
          aspectRatio: 100 / 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Statistics',
                style: Theme.of(context).textTheme.headline1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AverageCard(subTitle: 'Liters / Day', isMl: true, futureValue: Provider.of<WaterModel>(context, listen: false).averageLitersPerDay()),
                  AverageCard(subTitle: 'Liters / Week', isMl: true, futureValue: Provider.of<WaterModel>(context, listen: false).averageLitersPerWeek()),
                  AverageCard(subTitle: 'Cups / Day', isMl: false, futureValue: Provider.of<WaterModel>(context, listen: false).averageCupsPerDay()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

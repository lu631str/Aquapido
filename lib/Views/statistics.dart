import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../Widgets/WeeklyBarChart.dart';
import '../Widgets/DailyLineChart.dart';
import '../Widgets/AverageCard.dart';
import '../Models/WaterModel.dart';

class Statistics extends StatefulWidget {
  Statistics({Key key, this.title});

  final String title;

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool isDayDiagram = true;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.parse("2020-01-01 12:00:00"),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: AspectRatio(
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
              TextButton(
                child: Text('Date'),
                onPressed: () => _selectDate(context),
              ),
              ToggleSwitch(
                minWidth: 80.0,
                cornerRadius: 20.0,
                activeBgColors: [
                  [Color(0xFF91BBFB)],
                  [Color(0xFF91BBFB)]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Color(0xFFb5b5b5),
                inactiveFgColor: Colors.white,
                initialLabelIndex: this.isDayDiagram ? 0 : 1,
                totalSwitches: 2,
                labels: ['Day', 'Week'],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() {
                  if(index == 0) {
                    this.isDayDiagram = true;
                  } else {
                    this.isDayDiagram = false;
                  }
                  });
                },
              ),
              Expanded(
                child: Padding(
                  child: isDayDiagram ? DailyLineChart(Provider.of<WaterModel>(context, listen: false).getWaterListForToday()) : WeeklyBarChart(Provider.of<WaterModel>(context, listen: false).getWaterListFor7Days(selectedDate), selectedDate),
                  padding: EdgeInsets.all(1),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

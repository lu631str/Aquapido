import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_tracker/Utils/Constants.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../Widgets/goals/AchievementCircle.dart';
import '../Widgets/goals/DailyGoal.dart';
import '../Widgets/goals/MedalType.dart';
import '../Widgets/shared/InfoCard.dart';
import '../Models/WaterModel.dart';

class Goals extends StatefulWidget {
  Goals({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {

  int randomNumber =Random().nextInt(14) ;
  
  List<int> maxTotalWater = [10, 100, 300, 999];
  List<int> maxCups = [5, 100, 300];
  List<int> maxStreak = [100, 360, 500];

  MedalType getMedal(List<int> max, int current) {
    if (current < max[0]) {
      return MedalType.Bronze;
    } else if (current >= max[0] && current < max[1]) {
      return MedalType.Silver;
    } else if (current >= max[1]&& current < max[2]) {
      return MedalType.Gold;}


    else if (current >= max[2]) {
      return MedalType.Gold;
    } else {
      return MedalType.Gold; // error case
    }
  }

  Color getRingColor(List<int> max, int current) {
    if (current < max[0]) {
      return Color.fromARGB(255, 168, 93, 30);
    } else if (current >= max[0] && current < max[1]) {
      return Color.fromARGB(255, 193, 193, 194);
    } else if (current >= max[1]) {
      return Color.fromARGB(255, 199, 177, 70);

    }else if (current >= max[2]) {
      return Color.fromARGB(255, 199, 177, 70);
    }
    else {
      return Color.fromARGB(153, 255, 0, 0); // error case
    }
  }

  int getMax(List<int> max, int current) {
    if (current < max[0]) {
      return max[0];
    } else if (current >= max[0] && current < max[1]) {
      return max[1];
    } else if (current >= max[1]&& current < max[2]) {
      return max[2];
    }
    else if (current >= max[2]) {
      return max[3];
    }
      else {
      return -1; // error case
    }
  }

  @override
  Widget build(BuildContext context) {

    int _totalWaterAmount = Provider.of<WaterModel>(context, listen: false).totalWaterAmount();
    int _totalCups = Provider.of<WaterModel>(context, listen: false).totalCups();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
                alignment: Alignment(0.60, -0.80),
                child: Column(
                  children: [
                    Card(
                        elevation: Constants.CARD_ELEVATION,
                        margin: Constants.CARD_MARGIN,
                        child: Column(children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder: getRingColor(
                                        maxTotalWater, (_totalWaterAmount~/1000).toInt()),
                                    medalType: getMedal(
                                        maxTotalWater,  (_totalWaterAmount~/1000).toInt()),
                                    isCurrentInt: false,
                                    currentDouble: (_totalWaterAmount / 1000).toDouble(),
                                    max: getMax(maxTotalWater, (_totalWaterAmount~/1000).toInt()),
                                    unit: 'Liter',
                                    subtitle: 'Total Water'),
                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder: getRingColor(
                                        maxCups, _totalCups),
                                    medalType:
                                        getMedal(maxCups, _totalCups),
                                    isCurrentInt: true,
                                    currentInt: _totalCups,
                                    max: getMax(maxCups, _totalCups),
                                    unit: 'Cups',
                                    subtitle: 'Total Cups'),
                                //mus nach implementierung von Streaks eingefügt werden
                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder:
                                        Color.fromARGB(255, 199, 177, 70),
                                    medalType: MedalType.Gold,
                                    isCurrentInt: true,
                                    currentInt: 60,
                                    max: maxStreak[0],
                                    unit: 'Days',
                                    subtitle: 'Streak')
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder:
                                        Color.fromARGB(255, 193, 193, 194),
                                    medalType: MedalType.Silver,
                                    isCurrentInt: true,
                                    currentInt: 260,
                                    max: 300,
                                    unit: 'Times',
                                    subtitle: 'Goals\nReached'),
                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder:
                                        Color.fromARGB(255, 168, 93, 30),
                                    medalType: MedalType.Bronze,
                                    isCurrentInt: true,
                                    currentInt: 5,
                                    max: 10,
                                    unit: 'Times',
                                    subtitle: 'Quick Add\n Used'),
                                //mus nach implementierung von Streaks eingefügt werden
                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder:
                                        Color.fromARGB(255, 193, 193, 194),
                                    medalType: MedalType.Silver,
                                    isCurrentInt: true,
                                    currentInt: 123,
                                    max: 250,
                                    unit: 'Times',
                                    subtitle: 'Drinks after\n reminder')
                              ])
                        ])),
                  ],
                )),
            DailyGoal(),
            InfoCard(title: "\nDid you know that...",
            text:tr("infos.info"+randomNumber.toString()),
            )
          ],
        ),
      ),
    );
  }
}

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/Widgets/goals/AchievementCircleDialog.dart';
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

  List<int> maxTotalWater = [20, 100, 1000 ];
  List<int> maxCups = [5, 280, 1000];
  List<int> maxStreak = [3, 28, 364];
  List<int> maxGoalReached = [7, 30, 364];
  List<int> maxQuickAddUsed = [5, 280, 1000];

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
    int _quickAddUsed = Provider.of<WaterModel>(context, listen: false).quickAddUsed();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
                alignment: Alignment(0.40, -0.80),
                child: Column(
                  children: [
                     Column(children: <Widget>[
                       Row(
                         children: [
                         IconButton(
                           onPressed: () {
                             showDialog(
                                 context: context,
                                 builder: (context) {
                                   return StatefulBuilder(builder: (context, setState) {
                                     return AchievementCircleDialog();


                                   });
                                 });
                           },
                           icon: Icon(Icons.info_outline),
                           padding: const EdgeInsets.only(right: 6),
                           constraints: BoxConstraints(),
                         )
                       ],
                       mainAxisAlignment: MainAxisAlignment.end,
                       ),
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
                                FutureBuilder(

                                    future:
                                    context.watch<WaterModel>().getStreakDays(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<int> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                        return AchievementCircle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1.0),
                                            colorBoarder:
                                            Color.fromARGB(255, 199, 177, 70),
                                            medalType: MedalType.Gold,
                                            isCurrentInt: true,
                                            currentInt:0,
                                            max: maxStreak[0],
                                            unit: 'Days',
                                            subtitle: 'Streak');
                                      else if (snapshot.hasData)
                                        return AchievementCircle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1.0),
                                            colorBoarder:getRingColor(maxGoalReached, snapshot.data),
                                            medalType: getMedal(maxGoalReached, snapshot.data),
                                            isCurrentInt: true,
                                            currentInt: snapshot.data,
                                            max: getMax(maxStreak, snapshot.data),
                                            unit: 'Days',
                                            subtitle: 'Streak');
                                      else if (snapshot.hasError) {
                                        return  AchievementCircle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1.0),
                                            colorBoarder:
                                            Color.fromARGB(255, 252, 13, 13),
                                            medalType: MedalType.Gold,
                                            isCurrentInt: true,
                                            currentInt: 0,
                                            max: 0,
                                            unit: 'Error',
                                            subtitle: 'Error');
                                      } else
                                        return   AchievementCircle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1.0),
                                            colorBoarder:
                                            Color.fromARGB(255, 255, 17, 36),
                                            medalType: MedalType.Gold,
                                            isCurrentInt: true,
                                            currentInt: 0,
                                            max: 0,
                                            unit: 'none',
                                            subtitle: 'none');
                                    }

                                ),
                              ]

                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FutureBuilder(

                                    future:
                                    context.watch<WaterModel>().getGoalsReached(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<int> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                        return AchievementCircle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1.0),
                                            colorBoarder:
                                            Color.fromARGB(255, 199, 177, 70),
                                            medalType: MedalType.Gold,
                                            isCurrentInt: true,
                                            currentInt:0,
                                            max: maxGoalReached[0],
                                            unit: 'Times',
                                            subtitle: 'Goals\nReached');
                                      else if (snapshot.hasData)
                                        return AchievementCircle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1.0),
                                            colorBoarder:getRingColor(maxGoalReached, snapshot.data),
                                            medalType: getMedal(maxGoalReached, snapshot.data),
                                            isCurrentInt: true,
                                            currentInt: snapshot.data,
                                            max: getMax(maxGoalReached, snapshot.data),
                                            unit: 'Times',
                                            subtitle: 'Goals\nReached');
                                      else if (snapshot.hasError) {
                                        return  AchievementCircle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1.0),
                                            colorBoarder:
                                            Color.fromARGB(255, 252, 13, 13),
                                            medalType: MedalType.Gold,
                                            isCurrentInt: true,
                                            currentInt: 0,
                                            max: 0,
                                            unit: 'Error',
                                            subtitle: 'Error');
                                      } else
                                        return   AchievementCircle(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 1.0),
                                          colorBoarder:
                                          Color.fromARGB(255, 255, 17, 36),
                                          medalType: MedalType.Gold,
                                          isCurrentInt: true,
                                          currentInt: 0,
                                          max: 0,
                                          unit: 'none',
                                          subtitle: 'none');
                                    }

                                ),

                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder:
                                        Color.fromARGB(255, 168, 93, 30),
                                    medalType: MedalType.Bronze,
                                    isCurrentInt: true,
                                    currentInt: _quickAddUsed,
                                    max: getMax(maxQuickAddUsed, _quickAddUsed),
                                    unit: 'Times',
                                    subtitle: 'Quick Add\n Used'),

                              ])
                        ])
                  ],
                )),
             const Divider(
                height: 20,
                thickness: 1,
                indent: 10,
                endIndent: 5,
              ),
            DailyGoal(),
             const Divider(
                height: 20,
                thickness: 1,
                indent: 5,
                endIndent: 10,
              ),
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

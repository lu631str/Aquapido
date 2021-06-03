import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Widgets/AchievementCircle.dart';
import '../Widgets/DailyGoal.dart';
import '../Widgets/MedalType.dart';

class Goals extends StatefulWidget {
  Goals({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  int _currentCupCounter = 4;
  int _totalWaterAmount = 2600;
  
  List<int> maxTotalWater = [10, 100, 300];
  List<int> maxCups = [5, 100, 300];
  List<int> maxStreak = [100, 360, 500];

  MedalType getMedal(List<int> max, int current) {
    if (current < max[0]) {
      return MedalType.Bronze;
    } else if (current >= max[0] && current < max[1]) {
      return MedalType.Silver;
    } else if (current >= max[1]) {
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
    } else {
      return Color.fromARGB(153, 255, 0, 0); // error case
    }
  }

  int getMax(List<int> max, int current) {
    if (current < max[0]) {
      return max[0];
    } else if (current >= max[0] && current < max[1]) {
      return max[1];
    } else if (current >= max[1]) {
      return max[2];
    } else {
      return -1; // error case
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        elevation: 2,
                        color: Color.fromARGB(255, 219, 237, 255),
                        margin: EdgeInsets.all(6),
                        child: Column(children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder: getRingColor(
                                        maxTotalWater, _totalWaterAmount),
                                    medalType: getMedal(
                                        maxTotalWater, _totalWaterAmount),
                                    isCurrentInt: false,
                                    currentDouble: _totalWaterAmount / 1000,
                                    max: maxTotalWater[0],
                                    unit: "Liter",
                                    subtitle: "Total Water"),
                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder: getRingColor(
                                        maxCups, _currentCupCounter),
                                    medalType:
                                        getMedal(maxCups, _currentCupCounter),
                                    isCurrentInt: true,
                                    currentInt: _currentCupCounter.round(),
                                    max: getMax(maxCups, _currentCupCounter),
                                    unit: "Cups",
                                    subtitle: "Total Cups"),
                                //mus nach implementierung von Streaks eingefügt werden
                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder:
                                        Color.fromARGB(255, 199, 177, 70),
                                    medalType: MedalType.Gold,
                                    isCurrentInt: true,
                                    currentInt: 60,
                                    max: maxStreak[0],
                                    unit: "Days",
                                    subtitle: "Streak")
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
                                    unit: "Times",
                                    subtitle: "Goals\nReached"),
                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder:
                                        Color.fromARGB(255, 168, 93, 30),
                                    medalType: MedalType.Bronze,
                                    isCurrentInt: true,
                                    currentInt: 5,
                                    max: 10,
                                    unit: "Times",
                                    subtitle: "Quick Add\n Used"),
                                //mus nach implementierung von Streaks eingefügt werden
                                AchievementCircle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    colorBoarder:
                                        Color.fromARGB(255, 193, 193, 194),
                                    medalType: MedalType.Silver,
                                    isCurrentInt: true,
                                    currentInt: 123,
                                    max: 250,
                                    unit: "Times",
                                    subtitle: "Drinks after\n reminder")
                              ])
                        ])),
                  ],
                )),
            DailyGoal()
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

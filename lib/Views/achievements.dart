import 'package:flutter/material.dart';
import 'package:water_tracker/Persistence/SharedPref.dart';
import 'package:water_tracker/Widgets/AchievementCircle.dart';

class Achievements extends StatefulWidget {
  Achievements({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  int _currentCupCounter = 0;
  int _currentCupSize = 300; // in ml
  int _totalWaterAmount = 0;
  double _dailyGoal = 2000;
  double _minGoal = 2000;
  double _maxGoal = 8000;
  List<int> maxTotalWater = [10, 100, 300];
  List<int> maxCups = [5, 100, 300];
  List<int> maxStreak = [100, 360, 500];

  List<Widget> _goalLabels = [Text('2000'), Text('8000')];

  int getMax(List<int> max, int current) {
    if (current < max[0]) {
      return max[0];
    } else if(current >= max[0] && current < max[1]) {
      return max[1];
    } else if(current >= max[1]) {
      return max[2];
    } else {
      return -1; // error case
    }
  }

  loadData() async {
    int currentCupSize = await loadCurrentCupSize();
    int counter = await loadCurrentCupCounter();
    int totalWaterAmount = 2600;
    setState(() {
      this._currentCupSize = currentCupSize;
      this._currentCupCounter += counter;
      this._totalWaterAmount += totalWaterAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
          alignment: Alignment(0.60, -0.80),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AchievementCircle(
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        colorBoarder: Color.fromARGB(153, 51, 0, 2),
                        isCurrentInt: false,
                        currentDouble: _totalWaterAmount / 1000,
                        max: maxTotalWater[0],
                        unit: "Liter",
                        subtitle: "Total Water"),
                    AchievementCircle(
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        colorBoarder: Color.fromARGB(136, 83, 82, 82),
                        isCurrentInt: true,
                        currentInt: _currentCupCounter.round(),
                        max: getMax(maxCups, _currentCupCounter),
                        unit: "Cups",
                        subtitle: "Total Cups"),
                    AchievementCircle(
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        colorBoarder: Color.fromARGB(153, 255, 223, 17),
                        isCurrentInt: true,
                        currentInt: 60,
                        max: maxStreak[0],
                        unit: "Days",
                        subtitle: "Streak"),
                  ]),
              const Divider(
                height: 40,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _goalLabels,
                    ),
                  ),
                  Slider(
                    value: _dailyGoal,
                    min: _minGoal,
                    max: _maxGoal,
                    divisions: (_maxGoal - _minGoal) ~/ 50,
                    label: _dailyGoal.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _dailyGoal = value;
                      });
                    },
                  ),
                ],
              ),
              Text('Daily Goal: ${_dailyGoal.toInt()} ml'),
            ],
          )),
    );
  }
}

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
}

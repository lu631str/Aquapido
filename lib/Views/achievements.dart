import 'package:flutter/material.dart';
import 'package:water_tracker/Persistence/SharedPref.dart';

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

  List<Widget> _goalLabels = [Text('2000'), Text('8000')];

  loadData() async {
    int currentCupSize = await loadCurrentCupSize();
    int counter = await loadCurrentCupCounter();
    int totalWaterAmount = await loadTotalWaterAmount();
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
                        max: 10,
                        unit: "Liter",
                        subtitle: "Total Water"),
                    AchievementCircle(
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        colorBoarder: Color.fromARGB(136, 83, 82, 82),
                        isCurrentInt: true,
                        currentInt: _currentCupCounter.round(),
                        max: 100,
                        unit: "Cups",
                        subtitle: "Total Cups"),
                    AchievementCircle(
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        colorBoarder: Color.fromARGB(153, 255, 223, 17),
                        isCurrentInt: true,
                        currentInt: 260,
                        max: 360,
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

class AchievementCircle extends StatelessWidget {
  Color color;
  Color colorBoarder;
  final String subtitle;
  int currentInt, max;
  double currentDouble;
  bool isCurrentInt;
  String unit;

  AchievementCircle(
      {this.color,
      this.currentInt,
      this.max,
      this.subtitle,
      this.unit,
      this.isCurrentInt,
      this.currentDouble,
      this.colorBoarder});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: this.color,
                  border: Border.all(
                    color: colorBoarder,
                    width: 9.0,
                  ),
                ),
                padding: EdgeInsets.all(6.0),
                transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                height: 110.0,
                width: 120.0,
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: this.color,
                    border: Border.all(
                      color: (this.color != Color.fromRGBO(255, 255, 255, 1.0))
                          ? Colors.white
                          : Colors.blue[100],
                      width: 2.0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      isCurrentInt == true
                          ? Text(
                              this.currentInt.toString() +
                                  "/" +
                                  this.max.round().toString(),
                              style: TextStyle(
                                color: (this.color !=
                                        Color.fromRGBO(255, 255, 255, 1.0))
                                    ? Colors.white
                                    : Colors.blue[100],
                                fontWeight: FontWeight.w900,
                                fontSize: 18.0,
                              ),
                            )
                          : Text(
                              this.currentDouble.toString() +
                                  "/" +
                                  this.max.round().toString(),
                              style: TextStyle(
                                color: (this.color !=
                                        Color.fromRGBO(255, 255, 255, 1.0))
                                    ? Colors.white
                                    : Colors.blue[100],
                                fontWeight: FontWeight.w900,
                                fontSize: 18.0,
                              ),
                            ),
                      Text(
                        this.unit,
                        style: TextStyle(
                          color:
                              (this.color != Color.fromRGBO(255, 255, 255, 1.0))
                                  ? Colors.black54
                                  : Colors.blue[100],
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
              alignment: Alignment.center,
              child: Text(
                this.subtitle + " ",
                style: TextStyle(
                  color: (this.color != Color.fromRGBO(231, 0, 0, 1.0))
                      ? Colors.black54
                      : Colors.blue[100],
                  fontSize: 18.0,
                ),
              )),
        ]);
  }
}

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
}

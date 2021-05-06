import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:water_tracker/Persistence/SharedPref.dart';
import 'package:water_tracker/Widgets/AchievementCircle.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:water_tracker/Widgets/MedalType.dart';

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
  double _recommended = 3000;
  final double _minGoal = 2000;
  final double _maxGoal = 6000;
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
      return Color.fromARGB(153, 255, 0, 0) ; // error case
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

  double _calcRecommendedPercentage() {
    var normalizedRecommended = this._recommended - this._minGoal;
    var range = this._maxGoal - this._minGoal;
    return (normalizedRecommended / range) * 100;
  }

  double _getAlignXValueFromPrecentage(percentage) {
    // 1.0 = 100%
    // 0.5 = 75%
    // 0.0 = 50%
    // -0.5 = 25%
    // -1.0 = 0%
    var decPercentage = percentage / 100;
    return (decPercentage * 2.0) - 1;
  }

  int _closestInteger(value, divisor) {
    // This method calculates the closest integer to 'value' which is dividable by divisor
    double c1 = value - (value % divisor);
    double c2 = (value + divisor) - (value % divisor);
    if (value - c1 > c2 - value) {
      return c2.toInt();
    } else {
      return c1.toInt();
    }
  }

  double _calcRecommend(weight) {
    // Kilogramm Körpergewicht x 30 bis 40 ml = empfohlene Trinkmenge pro Tag.
    // oder: 1ml Wasser pro 1 kcal pro Tag

    double recommended = weight * 40.0;

    if (recommended < _minGoal) {
      return _minGoal;
    } else {
      return _closestInteger(recommended, 100).toDouble();
    }
  }

  loadData() async {
    int currentCupSize = await loadCurrentCupSize();
    int counter = await loadCurrentCupCounter();
    int weight = await loadWeight();
    int totalWaterAmount = 2600;
    setState(() {
      this._currentCupSize = currentCupSize;
      this._currentCupCounter += counter;
      this._totalWaterAmount += totalWaterAmount;
      this._recommended = _calcRecommend(weight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Align(
          alignment: Alignment(0.60, -0.80),
          child: Column(
            children: [
              Card(
                  elevation: 2,
                  color: Color.fromARGB(255, 219, 237, 255),
                  margin: EdgeInsets.all(6),
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AchievementCircle(
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        colorBoarder: getRingColor(maxTotalWater,_totalWaterAmount),
                        medalType: getMedal(maxTotalWater,_totalWaterAmount),
                        isCurrentInt: false,
                        currentDouble: _totalWaterAmount / 1000,
                        max: maxTotalWater[0],
                        unit: "Liter",
                        subtitle: "Total Water"),
                    AchievementCircle(
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        colorBoarder: getRingColor(maxCups,_currentCupCounter),
                        medalType: getMedal(maxCups,_currentCupCounter),
                        isCurrentInt: true,
                        currentInt: _currentCupCounter.round(),
                        max: getMax(maxCups, _currentCupCounter),
                        unit: "Cups",
                        subtitle: "Total Cups"),
                    //mus nach implementierung von Streaks eingefügt werden
                    AchievementCircle(
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        colorBoarder: Color.fromARGB(255, 199, 177, 70),
                        medalType: MedalType.Gold,
                        isCurrentInt: true,
                        currentInt: 60,
                        max: maxStreak[0],
                        unit: "Days",
                        subtitle: "Streak"),
                  ])),

              Card(
                elevation: 2,
                color: Color.fromARGB(255, 219, 237, 255),
                margin: EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20),
                          child: Text('Daily Goal: ${_dailyGoal.toInt()} ml'),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.info_outline),
                          padding: const EdgeInsets.only(right: 6),
                          constraints: BoxConstraints(),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: FlutterSlider(
                        values: [_dailyGoal],
                        min: _minGoal,
                        max: _maxGoal,
                        step: FlutterSliderStep(step: 100),
                        jump: true,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          _dailyGoal = lowerValue;
                          setState(() {});
                        },
                        handler: FlutterSliderHandler(
                          decoration: BoxDecoration(),
                          child: Material(
                            type: MaterialType.circle,
                            color: Colors.blue,
                            elevation: 4,
                            child: Container(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.outlined_flag_outlined,
                                  size: 16,
                                )),
                          ),
                        ),
                        handlerAnimation: FlutterSliderHandlerAnimation(
                            curve: Curves.elasticOut,
                            reverseCurve: Curves.bounceIn,
                            duration: Duration(milliseconds: 400),
                            scale: 1.3),
                        tooltip: FlutterSliderTooltip(
                          format: (String value) {
                            double num =
                                double.parse(value); // get value as double
                            return num.toInt()
                                .toString(); // parse double to int and then to string
                          },
                          rightSuffix: Text(' ml'),
                          positionOffset:
                              FlutterSliderTooltipPositionOffset(top: 5),
                        ),
                        trackBar: FlutterSliderTrackBar(
                          inactiveTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.black12,
                            border: Border.all(width: 20, color: Colors.blue),
                          ),
                          activeTrackBar: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.blue.withOpacity(0.5)),
                          inactiveTrackBarHeight: 10,
                          activeTrackBarHeight: 10,
                        ),
                        hatchMark: FlutterSliderHatchMark(
                          labelsDistanceFromTrackBar: 54.0,
                          linesDistanceFromTrackBar: -2.0,
                          displayLines: true,
                          density: 0.2,
                          labels: [
                            FlutterSliderHatchMarkLabel(
                                percent: 0, label: Text('${_minGoal.toInt()}')),
                            FlutterSliderHatchMarkLabel(
                              percent: _calcRecommendedPercentage(),
                              label: Container(
                                child: Container(
                                    height: 16,
                                    child: VerticalDivider(
                                      color: Colors.green,
                                      thickness: 2,
                                    )),
                              ),
                            ),
                            FlutterSliderHatchMarkLabel(
                                percent: 100,
                                label: Text('${_maxGoal.toInt()}')),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Align(
                          alignment: Alignment(
                              _getAlignXValueFromPrecentage(
                                  _calcRecommendedPercentage()),
                              0),
                          child: Wrap(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Recommended',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
}

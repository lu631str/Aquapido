import 'package:flutter/material.dart';
import 'package:water_tracker/Persistence/SharedPref.dart';
import 'package:water_tracker/icons/my_flutter_app_icons.dart';

class Achievements  extends StatefulWidget {
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
        alignment: Alignment(0.60,-0.80),

      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,


          children: <Widget>[
       AchievementCircle(

          color: Color.fromRGBO(255, 255, 255, 1.0),
          current: _totalWaterAmount.toDouble()/1000,
          max: 10,
          subtitle: "Total Water"),

            AchievementCircle(

                color: Color.fromRGBO(255, 255, 255, 1.0),
                current: _currentCupCounter.toDouble(),
                max: 100,
                subtitle: "Total Cups"),

            AchievementCircle(

                color: Color.fromRGBO(255, 255, 255, 1.0),
                current: 4,
                max: 10,
                subtitle: "Streak"),







      ]
    ),
    ),
    );
  }
}







class AchievementCircle extends StatelessWidget {
  final Color color;
  final String  subtitle;
  double current,max;


  AchievementCircle({this.color, this.current, this.max, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,

      children: <Widget>[

        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: this.color,
            border: Border.all(
              color: Color.fromRGBO(231, 241, 248, 1.0),
              width: 3.0,
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
                width: 3.0,
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  this.current.round().toString() + "/" + this.max.round().toString(),
                  style: TextStyle(
                    color: (this.color != Color.fromRGBO(255, 255, 255, 1.0))
                        ? Colors.white
                        : Colors.blue[100],
                    fontWeight: FontWeight.w900,
                    fontSize: 20.0,
                  ),
                ),

                    Text(
                      this.subtitle,
                      style: TextStyle(
                        color: (this.color != Color.fromRGBO(255, 255, 255, 1.0))
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
    );
  }
}


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
  }

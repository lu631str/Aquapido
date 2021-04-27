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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: CircleBadge(
          color: Color.fromRGBO(255, 255, 255, 1.0),
          title: "4,5/10",
          subtitle: "Total Water"),
    );
  }
}







class CircleBadge extends StatelessWidget {
  final Color color;
  final String title, subtitle;

  CircleBadge({this.color, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: 45.0,
            height: 60.0,
            transform: Matrix4.translationValues(0.0, 102.0, 0.0),

            child: Text('Test')


            ),
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
                  this.title,
                  style: TextStyle(
                    color: (this.color != Color.fromRGBO(255, 255, 255, 1.0))
                        ? Colors.white
                        : Colors.blue[100],
                    fontWeight: FontWeight.w900,
                    fontSize: 20.0,
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

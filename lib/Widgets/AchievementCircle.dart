import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:grafpix/icons.dart';
import 'MedalType.dart';

class AchievementCircle extends StatelessWidget {
  final Color color;
  final Color colorBoarder;
  final String subtitle;
  final int currentInt, max;
  final MedalType medalType;

  final double currentDouble;
  final bool isCurrentInt;
  final String unit;

  AchievementCircle(
      {this.color,
      this.currentInt,
      this.max,
      this.subtitle,
      this.medalType,
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
          Container(height: 10.0), // Space Top
          Stack(
            overflow: Overflow.visible,
            //mainAxisAlignment: MainAxisAlignment.start,
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
                height: 110.0,
                width: 120.0,
                alignment: Alignment.center,
                child: CircularPercentIndicator(
                  startAngle: 180.0,
                  radius: 80.0,
                  lineWidth: 5.0,
                  percent: (isCurrentInt == true)
                      ? (currentInt / max).toDouble()
                      : (currentDouble / max),
                  center: isCurrentInt == true
                      ? new Text(
                          this.currentInt.toString() +
                              '/' +
                              this.max.round().toString() +
                              '\n' +
                              this.unit,
                          style: TextStyle(
                            color: (this.color !=
                                    Color.fromRGBO(255, 255, 255, 1.0))
                                ? Colors.white
                                : Colors.blue[100],
                            fontWeight: FontWeight.w900,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : new Text(
                          this.currentDouble.toString() +
                              '/' +
                              this.max.round().toString() +
                              '\n' +
                              this.unit,
                          style: TextStyle(
                            color: (this.color !=
                                    Color.fromRGBO(255, 255, 255, 1.0))
                                ? Colors.white
                                : Colors.blue[100],
                            fontWeight: FontWeight.w900,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                  progressColor: Colors.blue,
                ),
              ),
              new Positioned(
                left: 42,
                bottom: -15,
                child: PixMedal(
                  icon: PixIcon.drop,
                  medalType: medalType,
                  radius: 18.0,
                  iconSize: 10.0,
                  iconColor: Colors.blue,
                ),
              ),
            ],
          ),
          Container(
              child: Text(
            '\n' + this.subtitle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: (this.color != Color.fromRGBO(231, 0, 0, 1.0))
                  ? Colors.black54
                  : Colors.blue[100],
              fontSize: 16.0,
            ),
          )),
          Container(height: 20.0),
        ]);
  }
}

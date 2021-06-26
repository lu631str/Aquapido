import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:grafpix/icons.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    return Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.height / 150),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Container(height: 10.0), // Space Top
              Stack(
                clipBehavior: Clip.none,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: this.color,
                      border: Border.all(
                        color: colorBoarder,
                        width: MediaQuery.of(context).size.width / 50,
                      ),
                    ),
                    padding: EdgeInsets.all(0.0),
                    height: MediaQuery.of(context).size.height / 7.5,
                    width: MediaQuery.of(context).size.width / 3.5,
                    alignment: Alignment.center,
                    child: CircularPercentIndicator(
                      startAngle: 180.0,
                      radius: MediaQuery.of(context).size.height / 10,
                      lineWidth: MediaQuery.of(context).size.width / 80,
                      percent: (isCurrentInt == true)
                          ? (currentInt / max).toDouble()
                          : (currentDouble / max),
                      center: isCurrentInt == true
                          ? new Container(
                              height: MediaQuery.of(context).size.height / 25.5,
                              width: MediaQuery.of(context).size.width / 0,
                              child: AutoSizeText(
                                this.currentInt.toString() +
                                    '/' +
                                    this.max.round().toString() +
                                    '\n' +
                                    this.unit,
                                maxLines: 2,
                                minFontSize: 2,
                                style: TextStyle(
                                  color: (this.color !=
                                          Color.fromRGBO(255, 255, 255, 1.0))
                                      ? Colors.white
                                      : Colors.blue[100],
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              ))
                          : new Container(
                              height: MediaQuery.of(context).size.height / 25.5,
                              width: MediaQuery.of(context).size.width / 0,
                              child: AutoSizeText(
                                this.currentDouble.toString() +
                                    '/' +
                                    this.max.round().toString() +
                                    '\n' +
                                    this.unit,
                                maxLines: 2,
                                minFontSize: 2,
                                style: TextStyle(
                                  color: (this.color !=
                                          Color.fromRGBO(255, 255, 255, 1.0))
                                      ? Colors.white
                                      : Colors.blue[100],
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              )),
                      progressColor: Colors.blue,
                    ),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: MediaQuery.of(context).size.height / 6.7 -
                        MediaQuery.of(context).padding.top,
                    alignment: Alignment.bottomCenter,
                    child: PixMedal(
                      icon: PixIcon.drop,
                      medalType: medalType,
                      radius: MediaQuery.of(context).size.height / 45,
                      iconSize: MediaQuery.of(context).size.height / 60,
                      iconColor: Colors.blue,
                    ),
                  ),
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 3.4,
                  child: AutoSizeText(
                '\n' + this.subtitle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                maxLines: 3,
                minFontSize: 6,
                style: TextStyle(
                  color: (this.color != Color.fromRGBO(231, 0, 0, 1.0))
                      ? Colors.black
                      : Colors.blue[100],
                  fontSize: 16.0,
                ),
              )),
            ]));
  }
}

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/Persistence/Database.dart';
import 'package:provider/provider.dart';
import '../Models/WaterModel.dart';


class AverageCard extends StatelessWidget {
  final String subTitle;
  final Future<double> futureValue;
  final double cardSize = 98;
  final double fontSize = 20.0;

  AverageCard({this.subTitle, this.futureValue, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Container(
          child: Column(
            children: [
              Image.asset(
                'assets/images/average_sign.jpg',
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: FutureBuilder(
                    future: futureValue,
                    builder:
                        (BuildContext context, AsyncSnapshot<double> snapshot) {
                      return new Text(
                        '${snapshot.data}',
                        style: TextStyle(fontSize: fontSize),
                      );
                    }),
              ),
              Text(subTitle),
            ],
          ),
          width: cardSize,
          height: cardSize,
        ),
      ),
    );
  }
}

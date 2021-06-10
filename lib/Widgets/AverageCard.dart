import 'package:flutter/material.dart';
import 'dart:developer';

class AverageCard extends StatelessWidget {
  final String subTitle;
  final Future<double> futureValue;
  final bool isMl;
  final double cardSize = 98;
  final double fontSize = 20.0;

  AverageCard({this.subTitle, this.futureValue, this.isMl, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          child: Column(
            children: [
              Image.asset(
                'assets/images/average_sign.jpg',
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: FutureBuilder(
                    future: futureValue,
                    builder:
                        (BuildContext context, AsyncSnapshot<double> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Text(
                          '0.0',
                          style: TextStyle(fontSize: fontSize),
                        );
                      else if (snapshot.hasData)
                        return Text(
                          '${isMl == true ? snapshot.data / 1000 : snapshot.data}',
                          style: TextStyle(fontSize: fontSize),
                        );
                      else if (snapshot.hasError) {
                        log('Error while fetching \'$subTitle\': ${snapshot.error}');
                        return Text('Error');
                      }
                      else
                        return Text('None');
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

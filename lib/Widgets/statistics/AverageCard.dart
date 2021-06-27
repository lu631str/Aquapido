import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../src/Utils/Constants.dart';

class AverageCard extends StatelessWidget {
  final String subTitle;
  final Future<double> futureValue;
  final bool isMl;
  final double cardSize = 98;
  final double fontSize = 20.0;

  AverageCard({this.subTitle, this.futureValue, this.isMl, Key key})
      : super(key: key);

  String _formatValue(double value) {
    return (value).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
      elevation: Constants.CARD_ELEVATION,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            children: [
              Image.asset(
                'assets/images/average_sign.png',
                height: MediaQuery.of(context).size.height * 0.061,
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
                        return AutoSizeText(
                          '${isMl ? _formatValue(snapshot.data / 1000) : _formatValue(snapshot.data)}',
                          style: TextStyle(fontSize: fontSize),
                          maxLines: 1,
                        );
                      else if (snapshot.hasError) {
                        return Text('Error');
                      } else
                        return Text('None');
                    }),
              ),
              AutoSizeText(
                subTitle,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

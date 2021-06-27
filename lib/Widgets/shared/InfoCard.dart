import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../src/Utils/Constants.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String text;

  InfoCard({this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 10, left: 5, bottom: 20, right: 5),
      elevation: Constants.CARD_ELEVATION,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: Image.asset('assets/images/ausrufezeichen.png', scale: 7),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.44,
            height: MediaQuery.of(context).size.height / 6.8,
            child: AutoSizeText.rich(
              TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: this.title + '\n',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        )),
                    TextSpan(text: this.text, style: TextStyle(fontSize: 14))
                  ]),
              maxLines: 15,
              minFontSize: 2,
            ),
          )
        ],
      ),
    );
  }
}

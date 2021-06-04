import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String text;

  InfoCard({this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 219, 237, 255),
      elevation: 2,
      shape: RoundedRectangleBorder(
    side: BorderSide(color: Colors.blue, width: 1),
    borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(0.0),
            child: Image.asset('assets/images/ausrufezeichen.png', scale: 10),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            constraints: BoxConstraints(
                minWidth: 270, maxWidth: 270, minHeight: 110, maxHeight: 110),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: this.title + '\n\n',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        )),
                    TextSpan(text: this.text, style: TextStyle(fontSize: 14))
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

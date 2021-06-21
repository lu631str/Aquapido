import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String text;

  InfoCard({this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      //margin: EdgeInsets.all(4.0),
      color: Color.fromARGB(255, 219, 237, 255),
      elevation: 2,
      shape: RoundedRectangleBorder(
    side: BorderSide(color: Colors.blue, width: 1),
    borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: Image.asset('assets/images/ausrufezeichen.png', scale: 10),
          ),
          Container(
          //margin: EdgeInsets.fromLTRB(0,10,0,10),
            width: MediaQuery.of(context).size.width / 1.5 ,
            height: MediaQuery.of(context).size.height / 6.8,
            // height: SizeConfig.screenHeight,
            child: AutoSizeText.rich(
              //textAlign: TextAlign.start,
              TextSpan(
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
              maxLines: 15,
              minFontSize: 2,
            ),
          )
        ],
      ),
    );
  }
}

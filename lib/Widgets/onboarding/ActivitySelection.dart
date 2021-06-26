import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:water_tracker/Models/SettingsModel.dart';
import 'package:provider/provider.dart';

class ActivitySelection extends StatefulWidget {
  @override
  _ActivitySelectionState createState() => _ActivitySelectionState();
}

class _ActivitySelectionState extends State<ActivitySelection> {

  int selectActivity;

  @override
  void initState() {
    super.initState();
    selectActivity = 1;
  }

  setSelectActivity(int val) {
    setState(() {
      selectActivity = val;
    });
  }


  @override
  Widget build(BuildContext context) {
    return
      Expanded(

      child:Container (
      margin: EdgeInsets.fromLTRB(0,MediaQuery.of(context).size.height / 25 -
          MediaQuery.of(context).padding.top / 25,0,0),

      child:SingleChildScrollView(

     child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(

            width: MediaQuery.of(context).size.width/ 1.2,
            //height:MediaQuery.of(context).size.height/ 20,
            margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.width/ 50),

            decoration: BoxDecoration(
                color: (selectActivity == 1)
                    ? Colors.blue
                    : Colors.transparent,
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            // color: Colors.blue,
            child: RadioListTile(
              value: 1,
              title: Text(
                tr('onbording.activity.low'),
                style: (selectActivity == 1)
                    ? TextStyle(color: Colors.white)
                    : TextStyle(color: Colors.black),
                textAlign: TextAlign.start,
              ),
              groupValue: selectActivity,
              activeColor: Colors.white,
              onChanged: (val) {
                print("Radio $val");
                setSelectActivity(val);
                context.read<SettingsModel>().updateActivity("low");
              },
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width/ 1.2,
             //height:MediaQuery.of(context).size.width/ 6,
              margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.width/ 50),
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: (selectActivity == 2)
                      ? Colors.blue
                      : Colors.transparent,
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(20))),
              child: RadioListTile(
                value: 2,
                title: Text(
                  tr('onbording.activity.normal'),
                  textAlign: TextAlign.start,
                  style: (selectActivity == 2)
                      ? TextStyle(color: Colors.white)
                      : TextStyle(color: Colors.black),
                ),
                groupValue: selectActivity,
                activeColor: Colors.white,
                onChanged: (val) {
                  print("Radio $val");
                  setSelectActivity(val);
                  context.read<SettingsModel>().updateActivity("normal");
                },
              )),
          Container(
              width: MediaQuery.of(context).size.width/ 1.2,
              //height:MediaQuery.of(context).size.width/ 6,
              margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.width/ 50),
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: (selectActivity == 3)
                      ? Colors.blue
                      : Colors.transparent,
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(20))),
              child: RadioListTile(
                value: 3,
                title: Text(
                  tr('onbording.activity.high'),
                  textAlign: TextAlign.start,
                  style: (selectActivity == 3)
                      ? TextStyle(color: Colors.white)
                      : TextStyle(color: Colors.black),
                ),
                groupValue: selectActivity,
                activeColor: Colors.white,
                onChanged: (val) {
                  print("Radio $val");
                  setSelectActivity(val);
                  context.read<SettingsModel>().updateActivity("high");
                },
              )),
          Container(
              width: MediaQuery.of(context).size.width/ 1.2,
             // height:MediaQuery.of(context).size.width/ 12,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: (selectActivity == 4)
                      ? Colors.blue
                      : Colors.transparent,
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(20))),
              child: RadioListTile(
                value: 4,
                title: Text(
                  tr('onbording.activity.very_high'),
                  textAlign: TextAlign.start,
                  style: (selectActivity == 4)
                      ? TextStyle(color: Colors.white)
                      : TextStyle(color: Colors.black),
                ),
                groupValue: selectActivity,
                activeColor: Colors.white,
                onChanged: (val) {
                  print("Radio $val");
                  setSelectActivity(val);
                  context.read<SettingsModel>().updateActivity("very_high");
                },
              )),
        ],
     ),
      ),
      ),
      );

  }
}

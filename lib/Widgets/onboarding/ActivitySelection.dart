import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../src/Models/SettingsModel.dart';

class ActivitySelection extends StatefulWidget {
  @override
  _ActivitySelectionState createState() => _ActivitySelectionState();
}

class _ActivitySelectionState extends State<ActivitySelection> {
  int selectActivity;

  @override
  void initState() {
    super.initState();
    String activity = context.read<SettingsModel>().activity;
    if(activity == 'low') {
      selectActivity = 1;
    } else if(activity == 'normal') {
      selectActivity = 2;
    } else if(activity == 'high') {
      selectActivity = 3;
    } else {
      selectActivity = 4;
    }
  }

  setSelectActivity(int val) {
    setState(() {
      selectActivity = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.fromLTRB(
            0,
            MediaQuery.of(context).size.height / 25 -
                MediaQuery.of(context).padding.top / 25,
            0,
            0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: EdgeInsets.fromLTRB(
                    0, 0, 0, MediaQuery.of(context).size.width / 50),

                decoration: BoxDecoration(
                    color: (selectActivity == 1)
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
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
                    setSelectActivity(val);
                    context.read<SettingsModel>().updateActivity("low");
                  },
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  margin: EdgeInsets.fromLTRB(
                      0, 0, 0, MediaQuery.of(context).size.width / 50),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: (selectActivity == 2)
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
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
                      setSelectActivity(val);
                      context.read<SettingsModel>().updateActivity("normal");
                    },
                  )),
              Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  margin: EdgeInsets.fromLTRB(
                      0, 0, 0, MediaQuery.of(context).size.width / 50),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: (selectActivity == 3)
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
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
                      setSelectActivity(val);
                      context.read<SettingsModel>().updateActivity("high");
                    },
                  )),
              Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: (selectActivity == 4)
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
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

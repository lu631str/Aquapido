import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import '../../Models/SettingsModel.dart';

class GenderSelection extends StatefulWidget {
  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  int selectGender;
  @override
  void initState() {
    super.initState();
    selectGender = 1;
  }

  setSelectGender(int val) {
    setState(() {
      selectGender = val;
      context.read<SettingsModel>().updateGender("male");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2.3,
          // height: MediaQuery.of(context).size.height /9 - MediaQuery.of(context).padding.top,
          margin: EdgeInsets.all(MediaQuery.of(context).size.height / 25 -
              MediaQuery.of(context).padding.top / 25),
          //padding: EdgeInsets.all(0),

          decoration: BoxDecoration(
              color: (selectGender == 1) ? Colors.blue : Colors.transparent,
              border: Border.all(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          // color: Colors.blue,
          child: RadioListTile(
            dense: true,
            value: 1,
            title: AutoSizeText(
              "Male",
              minFontSize: 6,
              maxLines: 1,
              style: (selectGender == 1)
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: Colors.black),
              textAlign: TextAlign.start,
            ),
            groupValue: selectGender,
            activeColor: Colors.white,
            onChanged: (val) {
              print("Radio $val");
              setSelectGender(val);
              context.read<SettingsModel>().updateGender("male");
            },
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width / 2.3,
            //height: MediaQuery.of(context).size.height /8 - MediaQuery.of(context).padding.top,
            //margin: EdgeInsets.all(MediaQuery.of(context).size.height /25 - MediaQuery.of(context).padding.top/25),
            decoration: BoxDecoration(
                color: (selectGender == 2) ? Colors.blue : Colors.transparent,
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: RadioListTile(
              dense: true,
              value: 2,
              title: AutoSizeText(
                "Female",
                minFontSize: 6,
                maxLines: 1,
                textAlign: TextAlign.start,
                style: (selectGender == 2)
                    ? TextStyle(color: Colors.white)
                    : TextStyle(color: Colors.black),
              ),
              groupValue: selectGender,
              activeColor: Colors.white,
              onChanged: (val) {
                print("Radio $val");
                setSelectGender(val);
                context.read<SettingsModel>().updateGender("female");
              },
            )),
      ],
    );
  }
}

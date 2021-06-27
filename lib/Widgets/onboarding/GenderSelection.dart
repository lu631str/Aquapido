import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import '../../src/Models/SettingsModel.dart';

class GenderSelection extends StatefulWidget {
  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  int selectGender;

  @override
  void initState() {
    super.initState();
    String gender = context.read<SettingsModel>().gender;
    if(gender == 'male') {
      selectGender = 1;
    } else {
      selectGender = 2;
    }
  }

  setSelectGender(int val) {
    setState(() {
      selectGender = val;
      if(val == 1) {
        context.read<SettingsModel>().updateGender("male");
      } else {
        context.read<SettingsModel>().updateGender("female");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2.3,
          margin: EdgeInsets.all(MediaQuery.of(context).size.height / 25 -
              MediaQuery.of(context).padding.top / 25),
          decoration: BoxDecoration(
              color: (selectGender == 1)
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: RadioListTile(
            dense: true,
            value: 1,
            title: AutoSizeText(
              tr('settings.gender.male'),
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
              setSelectGender(val);
            },
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width / 2.3,
            //height: MediaQuery.of(context).size.height /8 - MediaQuery.of(context).padding.top,
            //margin: EdgeInsets.all(MediaQuery.of(context).size.height /25 - MediaQuery.of(context).padding.top/25),
            decoration: BoxDecoration(
                color: (selectGender == 2)
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: RadioListTile(
              dense: true,
              value: 2,
              title: AutoSizeText(
                tr('settings.gender.female'),
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
                setSelectGender(val);
              },
            )),
      ],
    );
  }
}

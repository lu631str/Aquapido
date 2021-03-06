import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../src/Models/SettingsModel.dart';
import '../../src/Utils/Constants.dart';

class WeightSelection extends StatefulWidget {
  @override
  _WeightSelectionState createState() => _WeightSelectionState();
}

class _WeightSelectionState extends State<WeightSelection> {
  String _weightUnit = 'kg';
  int _selectedWeight = 45;

  @override
  void initState() {
    super.initState();
    _selectedWeight = context.read<SettingsModel>().weight;
  }

  setSelectWeight(int value) {
    setState(() {
      _selectedWeight = value;
      context.read<SettingsModel>().setWeight(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          0,
          MediaQuery.of(context).size.height / 25 -
              MediaQuery.of(context).padding.top / 25,
          0,
          0),
      width: MediaQuery.of(context).size.width / 2,
      child: Card(
        elevation: Constants.CARD_ELEVATION,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: NumberPicker(
          value: _selectedWeight,
          minValue: 40,
          maxValue: 150,
          haptics: true,
          itemCount: 5,
          itemHeight: 32,
          textMapper: (numberText) => numberText + ' ' + _weightUnit,
          onChanged: (value) => setState(
            () => setSelectWeight(value),
          ),
        ),
      ),
    );
  }
}

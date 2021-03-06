import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';

import '../../src/Models/SettingsModel.dart';
import '../../src/Utils/Constants.dart';

class DailyGoalWidget extends StatelessWidget {
  final double _minGoal = 2000;
  final double _maxGoal = 6000;

  DailyGoalWidget({Key key}) : super(key: key);

  double _calcRecommendedPercentage(weight, gender, activity) {
    var normalizedRecommended =
        this._calcRecommend(weight, gender, activity) - this._minGoal;
    var range = this._maxGoal - this._minGoal;
    return (normalizedRecommended / range) * 100;
  }

  double _getAlignXValueFromPercentage(percentage) {
    // 1.0 = 100%
    // 0.5 = 75%
    // 0.0 = 50%
    // -0.5 = 25%
    // -1.0 = 0%
    var decPercentage = percentage / 100;
    return (decPercentage * 2.0) - 1;
  }

  int _closestInteger(value, divisor) {
    // This method calculates the closest integer to 'value' which is dividable by divisor
    double c1 = value - (value % divisor);
    double c2 = (value + divisor) - (value % divisor);
    if (value - c1 > c2 - value) {
      return c2.toInt();
    } else {
      return c1.toInt();
    }
  }

  double _calcGender(gender) {
    if (gender == "female") {
      return 39.0;
    }
    return 40.0;
  }

  double _calcActivity(activity) {
    if (activity == "low") {
      return -130;
    } else if (activity == "high") {
      return 500;
    } else if (activity == "very_high") {
      return 1000;
    } else {
      return 0;
    }
  }

  double _calcRecommend(weight, gender, activity) {
    // Kilogramm Körpergewicht x 30 bis 40 ml = empfohlene Trinkmenge pro Tag.
    // oder: 1ml Wasser pro 1 kcal pro Tag
    double recommended = weight * _calcGender(gender) + _calcActivity(activity);

    if (recommended < _minGoal) {
      return _minGoal;
    } else if (recommended > _maxGoal) {
      return _maxGoal;
    }
    return _closestInteger(recommended, 100).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Text(tr('goals.daily_goal.title') +
                  ': ${context.watch<SettingsModel>().dailyGoal.toInt()} ${Constants.WATER_UNIT_ML}'),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return SimpleDialog(
                          contentPadding: EdgeInsets.all(16),
                          title: Text('Information'),
                          children: [
                            Text(tr('goals.goals_dialog.calculation_info')),
                            SimpleDialogOption(
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:
                                      Text(tr('goals.goals_dialog.alright'))),
                            )
                          ],
                        );
                      });
                    });
              },
              icon: Icon(Icons.info_outline),
              padding: const EdgeInsets.only(right: 6),
              constraints: BoxConstraints(),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: FlutterSlider(
            values: [context.watch<SettingsModel>().dailyGoal],
            min: _minGoal,
            max: _maxGoal,
            step: FlutterSliderStep(step: 100),
            jump: true,
            onDragging: (handlerIndex, lowerValue, upperValue) {
              context.read<SettingsModel>().updateDailyGoal(lowerValue);
            },
            handler: FlutterSliderHandler(
              decoration: BoxDecoration(),
              child: Material(
                type: MaterialType.circle,
                color: Theme.of(context).primaryColor,
                elevation: Constants.CARD_ELEVATION,
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.outlined_flag_outlined,
                      size: 16,
                    )),
              ),
            ),
            handlerAnimation: FlutterSliderHandlerAnimation(
                curve: Curves.elasticOut,
                reverseCurve: Curves.bounceIn,
                duration: Duration(milliseconds: 400),
                scale: 1.3),
            tooltip: FlutterSliderTooltip(
              format: (String value) {
                double num = double.parse(value); // get value as double
                return num.toInt()
                    .toString(); // parse double to int and then to string
              },
              rightSuffix: Text(' ${Constants.WATER_UNIT_ML}'),
              positionOffset: FlutterSliderTooltipPositionOffset(top: 5),
            ),
            trackBar: FlutterSliderTrackBar(
              inactiveTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.black12,
                border: Border.all(width: 20, color: Colors.blue),
              ),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.blue.withOpacity(0.5)),
              inactiveTrackBarHeight: 10,
              activeTrackBarHeight: 10,
            ),
            hatchMark: FlutterSliderHatchMark(
              labelsDistanceFromTrackBar: 53.0,
              linesDistanceFromTrackBar: -2.0,
              displayLines: true,
              density: 0.2,
              labels: [
                FlutterSliderHatchMarkLabel(
                    percent: 0, label: Text('${_minGoal.toInt()}')),
                FlutterSliderHatchMarkLabel(
                  percent: _calcRecommendedPercentage(
                      context.watch<SettingsModel>().weight,
                      context.watch<SettingsModel>().gender,
                      context.watch<SettingsModel>().activity),
                  label: Container(
                    child: Container(
                        height: 16,
                        child: VerticalDivider(
                          color: Colors.green,
                          thickness: 2,
                        )),
                  ),
                ),
                FlutterSliderHatchMarkLabel(
                    percent: 100, label: Text('${_maxGoal.toInt()}')),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Align(
            alignment: Alignment(
                _getAlignXValueFromPercentage(_calcRecommendedPercentage(
                    context.watch<SettingsModel>().weight,
                    context.watch<SettingsModel>().gender,
                    context.watch<SettingsModel>().activity)),
                0),
            child: Wrap(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: tr('goals.daily_goal.recommended'),
                        style: TextStyle(color: Colors.black, fontSize: 13.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

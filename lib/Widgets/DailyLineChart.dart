import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../Models/Water.dart';

class DailyLineChart extends StatefulWidget {
  final List<Water> waterList;

  DailyLineChart(this.waterList);

  @override
  _DailyLineChartState createState() => _DailyLineChartState(waterList);
}

class _DailyLineChartState extends State<DailyLineChart> {
  List<int> _dayTimes = [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24]; // #13

  double _minX = 0; // hours
  double _maxX = 16; // hours, default 14
  double _minY = 0; // ml
  double _maxY = 4000; // ml

  double _lowerYBorder = 4000; // ml
  double _upperYBorder = 10000; // ml

  //16h -> Max = 4
  //18h -> Max = 3
  //20h -> Max = 2
  // ...
  int _dayTimesIndex = 4; // default 4
  List<double> _cummulatedWater = [];

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Water> waterList;

  _DailyLineChartState(this.waterList) {
    _cummulatedWater = [];

    if(waterList.isEmpty) {
      return;
    }

    // Get cummulated value for every moment
    waterList.forEach((water) {
      if (_cummulatedWater.isEmpty) {
        _cummulatedWater.add(water.cupSize.toDouble());
      } else {
        _cummulatedWater.add(_cummulatedWater.last + water.cupSize);
      }
    });

    // get highest value
    int maxWaterValue = _cummulatedWater.last.ceil();

    // set Y height dependending on the maximum value
    if(maxWaterValue >= _lowerYBorder && maxWaterValue < _upperYBorder) {
      _maxY = (maxWaterValue / 1000).ceil() * 1000.0;
    } else if(maxWaterValue >= _upperYBorder) {
      _maxY = _upperYBorder;
    } else {
      _maxY = _lowerYBorder;
    }

    DateTime firstTime = waterList.first.dateTime;

    // set X width depending on the start date
    for (var i = 0; i < _dayTimes.length; i++) {
      if(firstTime.hour <= _dayTimes[i]) {
        // if odd time, take next smaller even time
        _dayTimesIndex = firstTime.hour % 2 == 0 ? i : i - 1;

        int window = 24 - firstTime.hour;

        _maxX = window % 2 == 0 ? window.toDouble() : window.toDouble() + 1;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.9,
      child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: const Color(0xff3546a6),
          child: waterList.isEmpty ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Text('You drank no water this day :(',style: TextStyle(color: Colors.white)),
          ]) : Container(
              child: Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 10.0, top: 24, bottom: 12),
            child: LineChart(
              mainData(),
            ),
          ))),
    );
  }

  SideTitles _getBottomSideTitles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 22,
      margin: 8,
      getTextStyles: (value) => const TextStyle(
          color: Color(0xffb4c4d9), fontWeight: FontWeight.bold, fontSize: 16),
      getTitles: (value) {
        int compare = 0;
        for (var i = 0; i < 13; i++) {
          if(value.toInt() == compare) {
            return _dayTimes[_dayTimesIndex + i].toString();
          }
          compare += 2;
        }
        return '';
      },
    );
  }

  SideTitles _getLeftSideTitles() {
    return SideTitles(
          showTitles: true,
          reservedSize: 22,
          margin: 12,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xffb4c4d9),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            for (var i = 0; i < 10; i++) {
              if(value.toInt() == i + 1) {
                return value.toInt().toString() + 'L';
              }
            }
            return '';
          },
        );
  }

  List<FlSpot> _getSpots() {
    return _cummulatedWater
        .toList()
        .asMap()
        .map((i, waterValue) {
          double hour = waterList[i].dateTime.hour.toDouble();
          double minutesNormalized = waterList[i].dateTime.minute / 60;
          double secondsNormalized = (waterList[i].dateTime.second / 60) / 100;
          double xValue = hour + minutesNormalized + secondsNormalized - _dayTimes[_dayTimesIndex];

          if(waterValue > _maxY) {
            return MapEntry(i, FlSpot(xValue, _maxY / 1000));
          }
          return MapEntry(i, FlSpot(xValue, waterValue / 1000));
        })
        .values
        .toList();
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xffe7e8ec),
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xffe7e8ec),
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: _getBottomSideTitles(),
        leftTitles: _getLeftSideTitles(),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xffe7e8ec), width: 1)),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY / 1000,
      axisTitleData: FlAxisTitleData(
              bottomTitle: AxisTitle(
                  showTitle: true,
                  margin: 0,
                  titleText: 'Time of day',
                  textStyle: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center)),
      lineBarsData: [
        LineChartBarData(
          curveSmoothness: 0.1,
          preventCurveOverShooting: true,
          spots: _getSpots(),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}

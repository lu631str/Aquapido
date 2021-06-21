import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
    waterList.forEach((water) {
      if (_cummulatedWater.isEmpty) {
        _cummulatedWater.add(water.cupSize.toDouble());
      } else {
        _cummulatedWater.add(_cummulatedWater.last + water.cupSize);
      }
    });

    int maxWaterValue = _cummulatedWater.last.ceil();

    if(maxWaterValue > _lowerYBorder && maxWaterValue < _upperYBorder) {
      _maxY = (maxWaterValue / 1000).ceil() * 1000.0;
    } else if(maxWaterValue >= _upperYBorder) {
      _maxY = _upperYBorder;
    }

    DateTime firstTime = waterList.first.dateTime;

    for (var i = 0; i < _dayTimes.length; i++) {
      if(firstTime.hour <= _dayTimes[i]) {
        _dayTimesIndex = i;
        _maxX = 24 - firstTime.hour.toDouble();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: const Color(0xff3546a6),
          child: Container(
              child: Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 10.0, top: 24, bottom: 12),
            child: LineChart(
              mainData(),
            ),
          ))),
    );
  }

  SideTitles _getBottomSideTiles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 22,
      getTextStyles: (value) => const TextStyle(
          color: Color(0xffb4c4d9), fontWeight: FontWeight.bold, fontSize: 16),
      getTitles: (value) {
        switch (value.toInt()) {
          case 0:
            return _dayTimes[_dayTimesIndex].toString();
          case 2:
            return _dayTimes[_dayTimesIndex + 1].toString();
          case 4:
            return _dayTimes[_dayTimesIndex + 2].toString();
          case 6:
            return _dayTimes[_dayTimesIndex + 3].toString();
          case 8:
            return _dayTimes[_dayTimesIndex + 4].toString();
          case 10:
            return _dayTimes[_dayTimesIndex + 5].toString();
          case 12:
            return _dayTimes[_dayTimesIndex + 6].toString();
          case 14:
            return _dayTimes[_dayTimesIndex + 7].toString();
          case 16:
            return _dayTimes[_dayTimesIndex + 8].toString();
          case 18:
            return _dayTimes[_dayTimesIndex + 9].toString();
          case 20:
            return _dayTimes[_dayTimesIndex + 10].toString();
          case 22:
            return _dayTimes[_dayTimesIndex + 11].toString();
          case 24:
            return _dayTimes[_dayTimesIndex + 12].toString();
        }
        return '';
      },
      margin: 8,
    );
  }

  SideTitles _getLeftSideTiles() {
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
            switch (value.toInt()) {
              case 1:
                return '1L';
              case 2:
                return '2L';
              case 3:
                return '3L';
              case 4:
                return '4L';
              case 5:
                return '5L';
              case 6:
                return '6L';
              case 7:
                return '7L';
              case 8:
                return '8L';
              case 9:
                return '9L';
              case 10:
                return '10L';
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
        bottomTitles: _getBottomSideTiles(),
        leftTitles: _getLeftSideTiles(),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xffe7e8ec), width: 1)),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY / 1000,
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

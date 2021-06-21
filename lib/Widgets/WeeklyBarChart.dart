import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class WeeklyBarChart extends StatefulWidget {
  final List<double> waterListWeek;
  final DateTime startDate;

  WeeklyBarChart(this.waterListWeek, this.startDate);

  @override
  State<StatefulWidget> createState() =>
      WeeklyBarChartState(waterListWeek, startDate);
}

class WeeklyBarChartState extends State<WeeklyBarChart> {
  final double barWidth = 15;

  List<double> waterListWeek;
  double maxWaterValue = 0.0;
  DateTime startDate;
  double _maxY = 4000;
  double _lowerYBorder = 4000; // ml
  double _upperYBorder = 10000; // ml

  WeeklyBarChartState(this.waterListWeek, this.startDate) {
    List<double> listCopy = waterListWeek.map((value) => value).toList();
    maxWaterValue = listCopy.reduce(max);

    // set Y height dependending on the maximum value
    if (maxWaterValue >= _lowerYBorder && maxWaterValue < _upperYBorder) {
      _maxY = (maxWaterValue / 1000).ceil() * 1000.0;
    } else if (maxWaterValue >= _upperYBorder) {
      _maxY = _upperYBorder;
    } else {
      _maxY = _lowerYBorder;
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
              padding: const EdgeInsets.only(left: 10.0, top: 24, bottom: 12),
              child: BarChart(mainData()),
            ),
          )),
    );
  }

  List<BarChartGroupData> _getBarChartGroupData() {
    return waterListWeek
        .asMap()
        .map(
          (i, waterValue) => MapEntry(
            i,
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    width: barWidth,
                    y: waterValue / 1000,
                    colors: [Colors.lightBlueAccent, Colors.greenAccent])
              ],
              showingTooltipIndicators: [0],
            ),
          ),
        )
        .values
        .toList();
  }

  SideTitles _getBottomTitles() {
    return SideTitles(
      showTitles: true,
      getTextStyles: (value) => const TextStyle(
          color: Color(0xffb4c4d9), fontWeight: FontWeight.bold, fontSize: 14),
      margin: 26,
      reservedSize: 12,
      getTitles: (double value) {
        for (var i = 0; i < 7; i++) {
          if (value.toInt() == i) {
            int newValue = (startDate.weekday + i) % 7;
            switch (newValue) {
              case 0:
                return 'Su';
              case 1:
                return 'Mo';
              case 2:
                return 'Tu';
              case 3:
                return 'We';
              case 4:
                return 'Th';
              case 5:
                return 'Fr';
              case 6:
                return 'Sa';
              default:
                return '..';
            }
          }
        }
        return '..';
      },
    );
  }

  BarChartData mainData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: _maxY / 1000,
      barTouchData: BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.y.toString(),
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: _getBottomTitles(),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xffb4c4d9),
              fontWeight: FontWeight.bold,
              fontSize: 15),
          margin: 12,
          reservedSize: 22,
          getTitles: (value) {
            if (value == 1) {
              return '1L';
            } else if (value == 2) {
              return '2L';
            } else if (value == 3) {
              return '3L';
            } else if (value == 4) {
              return '4L';
            } else if (value == 5) {
              return '5L';
            } else if (value == 6) {
              return '6L';
            } else if (value == 7) {
              return '7L';
            } else if (value == 8) {
              return '8L';
            } else if (value == 9) {
              return '9L';
            } else if (value == 10) {
              return '10L';
            } else {
              return '';
            }
          },
        ),
        rightTitles: SideTitles(
            showTitles: true,
            margin: 10,
            reservedSize: 5,
            getTitles: (value) {
              return '';
            }),
      ),
      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (value) => (value % 1 == 0),
        getDrawingHorizontalLine: (value) => FlLine(
          color: const Color(0xffe7e8ec),
          strokeWidth: 0.5,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _getBarChartGroupData(),
    );
  }
}

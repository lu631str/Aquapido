import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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

  static const Color foregroundColor = Color(0xFFF2F2F2);

  List<Color> gradientColors = [
    const Color(0xffed882f),
    const Color(0xfff54831)
  ];

  WeeklyBarChartState(this.waterListWeek, this.startDate) {
    if(waterListWeek.isEmpty) {
      waterListWeek = [0,0,0,0,0,0,0];
      return;
    }
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
    return Padding(
        padding: EdgeInsets.only(top: 24, right: 8, bottom: 10, left: 7),
        child: BarChart(
              mainData(),
            ));

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
                    y: waterValue > _maxY ? _maxY / 1000 : waterValue / 1000,
                    colors: gradientColors)
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
          color: foregroundColor, fontWeight: FontWeight.bold, fontSize: 14),
      margin: 26,
      reservedSize: 12,
      getTitles: (double value) {
        for (var i = 0; i < 7; i++) {
          if (value.toInt() == i) {
            int newValue = (startDate.weekday + i) % 7;
            switch (newValue) {
              case 0:
                return 'statistics.chart.sunday'.tr();
              case 1:
                return 'statistics.chart.monday'.tr();
              case 2:
                return 'statistics.chart.tuesday'.tr();
              case 3:
                return 'statistics.chart.wednesday'.tr();
              case 4:
                return 'statistics.chart.thursday'.tr();
              case 5:
                return 'statistics.chart.friday'.tr();
              case 6:
                return 'statistics.chart.saturday'.tr();
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
                color: foregroundColor,
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
              color: foregroundColor,
              fontWeight: FontWeight.bold,
              fontSize: 15),
          margin: 12,
          reservedSize: 22,
          getTitles: (value) {
            for (var i = 0; i < 10; i++) {
              if(value.toInt() == i + 1) {
                return value.toInt().toString() + 'L';
              }
            }
            return '';
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
          color: foregroundColor,
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

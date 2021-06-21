import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../Models/Water.dart';

class WeeklyBarChart extends StatefulWidget {

  List<Water> waterListWeek;
  DateTime startDate;

  WeeklyBarChart(List<Water> this.waterListWeek, DateTime this.startDate);

  @override
  State<StatefulWidget> createState() => WeeklyBarChartState(waterListWeek, startDate);
}

class WeeklyBarChartState extends State<WeeklyBarChart> {
  final double barWidth = 15;

  List<Water> waterListWeek;
  DateTime startDate;

  WeeklyBarChartState(List<Water> this.waterListWeek, DateTime this.startDate);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xff3546a6),
        child: BarChart(mainData())
      ),
    );
  }

  List<BarChartGroupData> _getBarChartGroupData(List<double> dataList) {
    return dataList
        .asMap()
        .map((i, waterValue) => MapEntry(
            i,
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                    width: barWidth,
                    y: waterValue,
                    colors: [Colors.lightBlueAccent, Colors.greenAccent])
              ],
              showingTooltipIndicators: [0],
            )))
        .values
        .toList();
  }

  BarChartData mainData() {
    return BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 8,
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
                    rod.y.round().toString(),
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
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Color(0xffb4c4d9),
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                margin: 20,
                getTitles: (double value) {
                  switch (value.toInt()) {
                    case 0:
                      return 'Mo';
                    case 1:
                      return 'Di';
                    case 2:
                      return 'Mi';
                    case 3:
                      return 'Do';
                    case 4:
                      return 'Fr';
                    case 5:
                      return 'Sa';
                    case 6:
                      return 'So';
                    default:
                      return '..';
                  }
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Color(0xffb4c4d9),
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
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
                  } else {
                    return '';
                  }
                },
              ),
              rightTitles: SideTitles(
                  showTitles: true,
                  margin: 10,
                  reservedSize: 22,
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
            barGroups: _getBarChartGroupData([3.4, 4, 4.5, 1, 3, 2, 3.4]),
          );
  }
}

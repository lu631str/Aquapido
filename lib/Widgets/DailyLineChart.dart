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

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Water> waterList;

  _DailyLineChartState(this.waterList);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xff3546a6),
        child: Container(child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 10.0, top: 24, bottom: 12),
              child: LineChart(
                mainData(),
              ),))
      ),
    );
  }

  List<FlSpot> _getSpots() {
    print('length: ' + waterList.length.toString());
    List<double> cummulatedWater = [];
    waterList.forEach((water) {
      print('water: ' + water.toString());
      if(cummulatedWater.isEmpty) {
        cummulatedWater.add(water.cupSize.toDouble());
      } else {
        cummulatedWater.add(cummulatedWater.last + water.cupSize);
      }
    });

    print(cummulatedWater);

    return cummulatedWater.toList()
        .asMap()
        .map((i, waterValue) => MapEntry(
            i,
            FlSpot(i.toDouble(), waterValue / 1000)))
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
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 2,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xffb4c4d9),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '6';
              case 2:
                return '9';
              case 4:
                return '12';
              case 6:
                return '15';
              case 8:
                return '18';
              case 10:
                return '21';
              case 12:
                return '23';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
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
            }
            return '';
          },
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xffe7e8ec), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 7,
      lineBarsData: [
        LineChartBarData(
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

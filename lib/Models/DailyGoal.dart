import 'package:intl/intl.dart';

import '../Utils/utils.dart';

class DailyGoal {
  final DateTime dateTime;
  final int dailyGoal;


  DailyGoal({this.dateTime, this.dailyGoal });

  String _getDateString(DateTime dateTime) {
    return DateFormat('dd.MM.yy').format(dateTime);
  }


  Map<String, dynamic> toMap() => {
    'date_time': dateTime,
    'daily_goal': dailyGoal,
  };
}



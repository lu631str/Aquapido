import 'package:intl/intl.dart';

import '../Utils/utils.dart';

class DailyGoal {
  final DateTime dateTime;
  final bool dailyGoalReached;

  DailyGoal({this.dateTime, this.dailyGoalReached});

  String getDateString() {
    return DateFormat('dd.MM.yy').format(dateTime);
  }

  int getGoalReachedAsInteger() {
    return dailyGoalReached ? 1 : 0;
  }

  DailyGoal ofMap(DateTime dateTime, bool dailyGoal) {
    return new DailyGoal(dateTime: dateTime, dailyGoalReached: dailyGoal);
  }

  Map<String, dynamic> toMap() => {
    'date_time': getDateString(),
    'goal_reached': getGoalReachedAsInteger(),
  };
}



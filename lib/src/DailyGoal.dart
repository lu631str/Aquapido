import 'package:intl/intl.dart';

class DailyGoal {
  final DateTime dateTime;
  final bool dailyGoalReached;

  DailyGoal({this.dateTime, this.dailyGoalReached});

  String getDateString() {
    return DateFormat(DateFormat.YEAR_MONTH_DAY).format(dateTime);
  }

  int getGoalReachedAsInteger() {
    return dailyGoalReached ? 1 : 0;
  }

  Map<String, dynamic> toMap() => {
        'date_time': dateTime.millisecondsSinceEpoch,
        'goal_reached': getGoalReachedAsInteger(),
      };
}

import 'package:intl/intl.dart';

class WaterModel {
  final DateTime dateTime;
  final int cupSize;

  WaterModel({this.dateTime, this.cupSize});

  bool _isToday(dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return true;
    }
    return false;
  }

  String _getDateString(DateTime dateTime) {
    if (this._isToday(dateTime)) {
      return 'Today';
    } else {
      return DateFormat('dd.MM.yy').format(dateTime);
    }
  }

  String toDateString() {
    return '${this._getDateString(this.dateTime)} - ${DateFormat('kk:mm').format(this.dateTime)}';
  }

  String toCupSizeString() {
    return '${this.cupSize}ml';
  }

  String toString() {
    return this.toCupSizeString() + ' ' + toDateString();
  }

  Map<String, dynamic> toMap() {
    return {
      'date_time': dateTime.millisecondsSinceEpoch,
      'cup_size': cupSize,
    };
  }
}
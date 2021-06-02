import 'package:intl/intl.dart';

class Water {
  final DateTime dateTime;
  final int cupSize;

  bool isPlaceholder = false;

  Water({this.dateTime, this.cupSize});

  Water.placeholder(this.cupSize) :
  this.dateTime = DateTime.now(),
  this.isPlaceholder = true;

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

  String toCupSizeString() {
    if(this.isPlaceholder) {
      return "Add your first glass of water!";
    }
    return '${this.cupSize}ml';
  }

  String toDateString() {
    if(this.isPlaceholder) {
      return "";
    }
    return '${this._getDateString(this.dateTime)} - ${DateFormat('kk:mm').format(this.dateTime)}';
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
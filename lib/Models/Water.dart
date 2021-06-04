import 'package:intl/intl.dart';
import '../Utils/utils.dart';

class Water {
  final DateTime dateTime;
  final int cupSize;

  bool isPlaceholder = false;

  Water({this.dateTime, this.cupSize});

  Water.placeholder(this.cupSize) :
  this.dateTime = DateTime.now(),
  this.isPlaceholder = true;

  String _getDateString(DateTime dateTime) {
    if (isToday(dateTime)) {
      return 'Today';
    } else {
      return DateFormat('dd.MM.yy').format(dateTime);
    }
  }

  String toCupSizeString() {
    if(this.isPlaceholder) {
      return 'Add your first glass of water!';
    }
    return '${this.cupSize}ml';
  }

  String toDateString() {
    if(this.isPlaceholder) {
      return '';
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
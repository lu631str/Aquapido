import 'package:intl/intl.dart';
import 'package:water_tracker/Utils/utils.dart';

class WaterModel {
  final DateTime dateTime;
  final int cupSize;

  bool isPlaceholder = false;

  WaterModel({this.dateTime, this.cupSize});

  WaterModel.placeholder(this.cupSize) :
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
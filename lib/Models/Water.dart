import 'package:intl/intl.dart';
import '../Utils/utils.dart';

class Water {
  final DateTime dateTime;
  final int cupSize;

  bool isPlaceholder = false;

  Water({this.dateTime, this.cupSize});

  Water.placeholder(this.cupSize)
      : dateTime = DateTime.now(),
        isPlaceholder = true;

  String _getDateString(DateTime dateTime) {
    if (isToday(dateTime)) {
      return 'Today';
    }
    return DateFormat('dd.MM.yy').format(dateTime);
  }

  /// Returns CupSize String Representation.
  String toCupSizeString() {
    if(isPlaceholder) {
      return 'Add your first glass of water!';
    }
    return '${cupSize}ml';
  }

  /// Returns Date String Representation.
  String toDateString() {
    if(isPlaceholder) {
      return '';
    }
    return '${_getDateString(dateTime)} - ${DateFormat('kk:mm').format(dateTime)}';
  }

  /// Returns String Representation.
  @override
  String toString() => '${toCupSizeString()} ${toDateString()}'.trim();

  Map<String, dynamic> toMap() => {
        'date_time': dateTime.millisecondsSinceEpoch,
        'cup_size': cupSize,
      };
}

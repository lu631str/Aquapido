import 'package:intl/intl.dart';

import '../Utils/utils.dart';

class Water {
  final DateTime dateTime;
  final int cupSize;
  final AddType addType;

  bool isPlaceholder = false;

  Water({this.dateTime, this.cupSize, this.addType});

  Water.placeholder(this.cupSize)
      : dateTime = DateTime.now(), addType = AddType.button,
        isPlaceholder = true;

  String _getDateString(DateTime dateTime) {
    if (isSameDay(dateTime, DateTime.now())) {
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

  AddType getAddType() {
    return addType;
  }

  String toAddTypeString() {
    if(isPlaceholder) {
      return '';
    }
    return addType.toString().substring(addType.toString().indexOf('.') + 1);
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
        'add_type': addType.toString()
      };
}

enum AddType {  
   button,
   shake,
   power 
}

class WaterModel {
  final DateTime dateTime;
  final int cupSize;

  WaterModel({this.dateTime, this.cupSize});

  Map<String, dynamic> toMap() {
    return {
      'date_time': dateTime.millisecondsSinceEpoch,
      'cup_size': cupSize,
    };
  }
}
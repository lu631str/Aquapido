class WaterModel {
  final DateTime dateTime;
  final int cupSize;

  WaterModel({this.dateTime, this.cupSize});

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime.millisecondsSinceEpoch,
      'cupSize': cupSize,
    };
  }
}
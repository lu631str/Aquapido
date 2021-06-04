  /// Checks [dateTime] if it is today.
bool isToday(DateTime dateTime) {
  final DateTime now = DateTime.now();
  if (dateTime.day == now.day &&
      dateTime.month == now.month &&
      dateTime.year == now.year) {
    return true;
  }
  return false;
}

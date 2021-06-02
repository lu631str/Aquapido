bool isToday(dateTime) {
  DateTime now = DateTime.now();
  if (dateTime.day == now.day &&
      dateTime.month == now.month &&
      dateTime.year == now.year) {
    return true;
  }
  return false;
}

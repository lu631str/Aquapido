
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

int getImageIndex(int cupSize) {
    switch (cupSize) {
      case 100:
        return 0;
        break;
      case 200:
        return 1;
        break;
      case 300:
        return 2;
        break;
      case 330:
        return 3;
        break;
      case 400:
        return 4;
        break;
      case 500:
        return 5;
        break;
      default:
        return 6;
    }
  }

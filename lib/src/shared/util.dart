part of 'shared.dart';

String convertDateTime(DateTime dateTime) {
  String month = "";
  switch (dateTime.month) {
    case 1:
      month = 'Jan';
      break;
    case 2:
      month = 'Feb';
      break;
    case 3:
      month = 'Mar';
      break;
    case 4:
      month = 'Apr';
      break;
    case 5:
      month = 'May';
      break;
    case 6:
      month = 'Jun';
      break;
    case 7:
      month = 'Jul';
      break;
    case 8:
      month = 'Aug';
      break;
    case 9:
      month = 'Sep';
      break;
    case 10:
      month = 'Oct';
      break;
    case 11:
      month = 'Nov';
      break;
    default:
      month = 'Des';
  }
  return month +
      ' ${dateTime.day}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}

String convertDateChat(DateTime dateTime) {
  String month = "";
  switch (dateTime.month) {
    case 1:
      month = 'Jan';
      break;
    case 2:
      month = 'Feb';
      break;
    case 3:
      month = 'Mar';
      break;
    case 4:
      month = 'Apr';
      break;
    case 5:
      month = 'May';
      break;
    case 6:
      month = 'Jun';
      break;
    case 7:
      month = 'Jul';
      break;
    case 8:
      month = 'Aug';
      break;
    case 9:
      month = 'Sep';
      break;
    case 10:
      month = 'Oct';
      break;
    case 11:
      month = 'Nov';
      break;
    default:
      month = 'Des';
  }
  var now = DateTime.now();
  if (DateUtils.isSameDay(now, dateTime)) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  return month +
      ' ${dateTime.day}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}

String convertTimeChat(DateTime dateTime) {
  var now = DateTime.now();
  if (DateUtils.isSameDay(now, dateTime)) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  } else if (DateUtils.isSameDay(now, dateTime.add(Duration(days: 1)))) {
    return 'Yesterday';
  }

  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

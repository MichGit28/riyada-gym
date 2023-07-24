import 'package:intl/intl.dart';

// this method is used to get the time in the format of hh:mm a
String getTime(int value, {String formatStr = "hh:mm a"}) {
  var format = DateFormat(formatStr);
  return format.format(
      DateTime.fromMillisecondsSinceEpoch(value * 60 * 1000, isUtc: true));
}

// this method is used to get the date in the format of dd/MM/yyyy
String getStringDateToOtherFormate(String dateStr,
    {String inputFormatStr = "dd/MM/yyyy hh:mm aa",
    String outFormatStr = "hh:mm a"}) {
  var format = DateFormat(outFormatStr);
  return format.format(stringToDate(dateStr, formatStr: inputFormatStr));
}

DateTime stringToDate(String dateStr, {String formatStr = "hh:mm a"}) {
  var format = DateFormat(formatStr);
  return format.parse(dateStr);
}

DateTime dateToStartDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String dateToString(DateTime date, {String formatStr = "dd/MM/yyyy hh:mm a"}) {
  var format = DateFormat(formatStr);
  return format.format(date);
}

// this method is used to get the day title such as Today, Tomorrow, Yesterday, and the day name.
String getDayTitle(String dateStr, {String formatStr = "dd/MM/yyyy hh:mm a"}) {
  var date = stringToDate(dateStr, formatStr: formatStr);

  if (date.isToday) {
    return "Today";
  } else if (date.isTomorrow) {
    return "Tomorrow";
  } else if (date.isYesterday) {
    return "Yesterday";
  } else {
    var outFormat = DateFormat("E");
    return outFormat.format(date);
  }
}

extension DateHelpers on DateTime {
  bool get isToday {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == 0;
  }

  bool get isYesterday {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == -1;
  }

  bool get isTomorrow {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == 1;
  }
}

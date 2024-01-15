import 'package:flutter/material.dart';

class NotificationsState with ChangeNotifier {
  TextEditingController controller = TextEditingController();
  DateTime? _dateSelected;
  TimeOfDay? _timeSelected;

  set date(DateTime newDate) {
    _dateSelected = newDate;
    notifyListeners();
  }

  set time(TimeOfDay newTime) {
    _timeSelected = newTime;
    notifyListeners();
  }

  DateTime getAccurateDate() {
    return _dateSelected ??= DateTime.now();
  }

  TimeOfDay getAccurateTime() {
    return _timeSelected ??= TimeOfDay.now();
  }

  String dateToString() {
    _dateSelected ??= DateTime.now();
    return "${_dateSelected!.day}. ${_dateSelected!.month}. ${_dateSelected!.year}. g";
  }

  String timeToString() {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String hourLabel = addLeadingZeroIfNeeded(_timeSelected!.hour);
    final String minuteLabel = addLeadingZeroIfNeeded(_timeSelected!.minute);

    return '$hourLabel:$minuteLabel';
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}

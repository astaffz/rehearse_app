import 'package:flutter/material.dart';

class NotificationsState with ChangeNotifier {
  TextEditingController controller = TextEditingController();
  DateTime? _dateSelected;
  TimeOfDay? _timeSelected;
  int pageIndex = 0;
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
    return "${getAccurateDate().day}. ${getAccurateDate().month}. ${getAccurateDate().year}. g";
  }

  String timeToString() {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String hourLabel = addLeadingZeroIfNeeded(getAccurateTime().hour);
    final String minuteLabel = addLeadingZeroIfNeeded(getAccurateTime().minute);

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

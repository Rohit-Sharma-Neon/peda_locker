import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    var _dayPeriod = 0;
    this.currentTime = currentTime ?? DateTime.now();
    setLeftIndex(this.currentTime.hour % 12);
    setMiddleIndex(this.currentTime.minute ~/ 5);
    setRightIndex(this.currentTime.hour < 12 ? 0 : 1);
   // setRightIndex(_dayPeriod);
   // _fillRightList();
  }

  /*@override
  String? leftStringAtIndex(int index) {
    if (index >= 1 && index < 13) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 12) {
      return digits(index * 5, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index == 0) {
      return 'AM';
    } else if (index == 1) {
      return 'PM';
    }
    return null;
    *//*if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }*//*
  }

  void _fillRightList() {
    rightList = List.generate(2, (int index) {
      return '$index';
    });
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    _fillRightList();
  }


  @override
  String leftDivider() {
    return ":";
  }

  @override
  String rightDivider() {
    return ":";
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 1];
  }
*/

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 12) {
      if (index == 0) {
        return digits(12, 2);
      } else {
        return digits(index, 2);
      }
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 12) {
      return digits(index * 5, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index == 0) {
      return i18nObjInLocale(this.locale)["am"] as String?;
    } else if (index == 1) {
      return i18nObjInLocale(this.locale)["pm"] as String?;
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return ":";
  }

  @override
  String rightDivider() {
    return ":";
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 1];
  }

  @override
  DateTime finalTime() {
    int hour = currentLeftIndex() + 12 * currentRightIndex();
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
        hour, currentMiddleIndex() * 5, 0)
        : DateTime(currentTime.year, currentTime.month, currentTime.day, hour,
        currentMiddleIndex() * 5, 0);
  }

 /* @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        currentLeftIndex(),
        currentMiddleIndex() * 5,
        currentRightIndex())
        : DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        currentLeftIndex(),
        currentMiddleIndex() * 5,
        currentRightIndex());
  }*/
}

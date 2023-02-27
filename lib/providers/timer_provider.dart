import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart' as tz;

class TimerProvider extends ChangeNotifier {
  int remainingTime = 59;

  String getRemainingTime({required String checkOutDate}) {

    var duration = const Duration(seconds: 1);
    late DateTime eventTime;
    late int days;
    late int hours;
    late int minutes;
    late int seconds;
    late int timeDiff;
    late Timer timer;
    DateTime? tempDate;

    final detroit = tz.getLocation('Asia/Dubai');
    tz.setLocalLocation(detroit);

    tempDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(checkOutDate);
    final localizedDt = tz.TZDateTime.from(tempDate, detroit);
    var now = tz.TZDateTime.now(detroit);

    timeDiff = localizedDt.difference(now).inSeconds;

    timer = Timer.periodic(duration, (Timer t) {
      notifyListeners();
    });


    days = timeDiff ~/ (24 * 60 * 60) % 24;
    hours = timeDiff ~/ (60 * 60) % 24;
    minutes = (timeDiff ~/ 60) % 60;
    seconds = timeDiff % 60;
    // if (!mounted) {
    //   timer.cancel();
    // }
    return days.toString().padLeft(2, '0').toString() +
        "D " +
        hours.toString().padLeft(2, '0').toString() +
        "H " +
        minutes.toString().padLeft(2, '0').toString() +
        "M " +
        seconds.toString().padLeft(2, '0').toString() +
        "s ";
  }

  resetTime() {
    remainingTime = 59;
    notifyListeners();
  }

  String prettyDuration(Duration duration) {
    var components = <String>[];

    var days = duration.inDays;
    if (days != 0) {
      components.add('${days}d');
    }
    var hours = duration.inHours % 24;
    if (hours != 0) {
      components.add('${hours}h');
    }
    var minutes = duration.inMinutes % 60;
    if (minutes != 0) {
      components.add('${minutes}m');
    }

    var seconds = duration.inSeconds % 60;
    var centiseconds = (duration.inMilliseconds % 1000) ~/ 10;
    if (components.isEmpty || seconds != 0 || centiseconds != 0) {
      components.add('$seconds');
      if (centiseconds != 0) {
        components.add('.');
        components.add(centiseconds.toString().padLeft(2, '0'));
      }
      components.add('s');
    }
    return components.join();
  }
}

import 'package:flutter/material.dart';

class Helper{
  formatedTime({required int time}) {
          int h, m, s;

      h = time ~/ 3600;

      m = ((time - h * 3600)) ~/ 60;

      s = time - (h * 3600) - (m * 60);

      String result = "$h h:$m m";

      return result;
  }

   bool isValidTimeRange(TimeOfDay startTime, TimeOfDay endTime) {
    return ((endTime.hour > startTime.hour));
    // return ((endTime.hour > startTime.hour) || (endTime.minute > startTime.minute));
  }

  getDurationRangeHour(timestart, timeEnd){
    String startTimeString = timestart;
    String endTimeString = timeEnd;

    DateTime startTime = DateTime.parse("2023-02-16 $startTimeString:00");
    DateTime endTime = DateTime.parse("2023-02-16 $endTimeString:00");

    Duration duration = endTime.difference(startTime);

    int durationInSeconds = duration.inSeconds;
    double check_hour = durationInSeconds / 3600;

    return check_hour;

  }

  secondToHour(val){
    Duration duration = Duration(seconds: val);
    String hour = duration.toString().split('.').first.padLeft(8, "0");
    return hour;
  }
}
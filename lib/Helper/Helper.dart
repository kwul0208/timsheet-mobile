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
    return ((endTime.hour > startTime.hour) || (endTime.minute > startTime.minute))
        ;
  }
}
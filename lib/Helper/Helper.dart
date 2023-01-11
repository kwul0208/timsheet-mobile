class Helper{
  formatedTime({required int time}) {
          int h, m, s;

      h = time ~/ 3600;

      m = ((time - h * 3600)) ~/ 60;

      s = time - (h * 3600) - (m * 60);

      String result = "$h h:$m m";

      return result;
  }
}
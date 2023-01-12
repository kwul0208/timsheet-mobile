import 'package:flutter/cupertino.dart';

class TimesheetState extends ChangeNotifier{
  bool _refresh = true;
  bool get refresh => _refresh;

  void changeRefresh(){
    _refresh = !_refresh;

    notifyListeners();
  }
}
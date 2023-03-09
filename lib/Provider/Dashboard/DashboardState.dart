import 'package:flutter/cupertino.dart';

class DashboardState extends ChangeNotifier{
  bool _showAll = false;
  bool get showAll => _showAll;

  int _showIndex = 0;
  int get showIndex => _showIndex;
  
  void changeShowALl( index){
    _showAll = !_showAll;
    _showIndex = index;
    notifyListeners();
  }
}
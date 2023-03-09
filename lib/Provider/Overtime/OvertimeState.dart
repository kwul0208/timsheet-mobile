import 'package:flutter/cupertino.dart';

class OvertimeState extends ChangeNotifier{
  String _nameMonth = '';
  String get nameMonth => _nameMonth;

  void changeNameMonth(value){
    _nameMonth = value;
    notifyListeners();
  }

  int _indexO = 0;
  int get indexO => _indexO;

  void changeIndexO(int val){
    _indexO = val;
    notifyListeners();
  }
}
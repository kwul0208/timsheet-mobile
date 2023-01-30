import 'package:flutter/cupertino.dart';

class OvertimeState extends ChangeNotifier{
  String _nameMonth = '';
  String get nameMonth => _nameMonth;

  void changeNameMonth(value){
    _nameMonth = value;
    notifyListeners();
  }
}
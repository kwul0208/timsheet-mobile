import 'package:flutter/cupertino.dart';

class WFHState extends ChangeNotifier{

  int _indexO = 0;
  int get indexO => _indexO;

  void changeIndexO(int val){
    _indexO = val;
    notifyListeners();
  }
}
import 'package:flutter/cupertino.dart';

class WFHState extends ChangeNotifier{

  int _indexO = 0;
  int get indexO => _indexO;

  void changeIndexO(int val){
    _indexO = val;
    notifyListeners();
  }

  void changeRefresh(){
    notifyListeners();
  }

  // -- error --
  bool _error = false;
  bool get error => _error;
  String _message = '';
  String get message => _message;
  void changeError(bool val, String msg){
    _error = val;
    _message = msg;
    notifyListeners();
  }
}
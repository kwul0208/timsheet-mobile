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

  int _IndexMonth = 3;
  int get indexMonth => _IndexMonth;
  void changeIndexMonth(val){
    _IndexMonth = val;
    notifyListeners();
  }

  int _IndexYear = 3;
  int get indexYear => _IndexYear;
  void changeIndexYear(val){
    _IndexYear = val;
    notifyListeners();
  }

  bool _isLoad = false;
  bool get isLoad => _isLoad;
  void changeIsLoad(val){
    _isLoad = val;
    notifyListeners();
  }
  
  bool _loadDone = false;
  bool get loadDone => _loadDone;
  void changeLoadDone(val){
    _loadDone = val;
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
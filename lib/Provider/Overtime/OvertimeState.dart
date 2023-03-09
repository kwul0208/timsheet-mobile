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

  bool _refresh = true;
  bool get refresh => _refresh;

  void changeRefresh(){
    _refresh = !_refresh;
    notifyListeners();
  }

    // -- add loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void changeIsLoading(bool val){
    _isLoading = val;
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
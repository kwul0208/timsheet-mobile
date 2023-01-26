import 'package:flutter/cupertino.dart';

class MainState extends ChangeNotifier{
  bool _isLogin = false;
  bool get isLogin => _isLogin;

  void changeLogin( bool val){
    _isLogin = val;
    notifyListeners();
  }
}
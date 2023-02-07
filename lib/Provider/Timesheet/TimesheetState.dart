import 'package:flutter/cupertino.dart';

class TimesheetState extends ChangeNotifier{
  bool _refresh = true;
  bool get refresh => _refresh;

  void changeRefresh(){
    _refresh = !_refresh;

    notifyListeners();
  }


  //------- Assignment -------
  String _client = '';
  String get client => _client;
  String _service = '';
  String get service => _service;

  void changeAssignment(String clientVal, String serviceVal){
    _client = clientVal;
    _service = serviceVal;
    notifyListeners();
  }

  List _assignmentIds= [];
  List get assignmentIds => _assignmentIds;
  void changeAssignmentIds(val){
    _assignmentIds.addAll(val);
    notifyListeners();
  }

  // ------- Project ----------
  String _projetName = '';
  String get projectName => _projetName;
  void changeProjectName(String val){
    _projetName = val;
    notifyListeners();
  }

  // ------ Training -------
  String _trainingName = "";
  String get trainingName => _trainingName;
  void changeTrainingName(val){
    _trainingName = val.toString();
    notifyListeners();
  }

  void reset(){
    _client = "";
    _service = '';
    _assignmentIds= [];
    _projetName = '';
    _trainingName = "";
    notifyListeners();
  }

}
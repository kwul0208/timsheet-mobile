import 'package:flutter/cupertino.dart';

class TimesheetState extends ChangeNotifier{
  bool _refresh = true;
  bool get refresh => _refresh;

  void changeRefresh(){
    _refresh = !_refresh;

    notifyListeners();
  }


  // -- add loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void changeIsLoading(){
    _isLoading = !_isLoading;
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

  int? _indexA;
  int? get indexA => _indexA;
  void changeIndexA(val){
    _indexA = val;
    notifyListeners();
  }

  int? _indexS;
  int? get indexS => _indexS;
  void changeIndexS(val){
    _indexS = val;
    notifyListeners();
  }
 

  // ------- Project ----------
  String _projetName = '';
  String get projectName => _projetName;
  void changeProjectName(String val){
    _projetName = val;
    notifyListeners();
  }

  int? _indexSelectedProject;
  int? get indexSelectedProject => _indexSelectedProject;
  void changeIndexSelectedProject(val){
    _indexSelectedProject = val;
    notifyListeners();
  }

  // ------ Training -------
  String _trainingName = "";
  String get trainingName => _trainingName;
  void changeTrainingName(val){
    _trainingName = val.toString();
    notifyListeners();
  }

  // ------ employee -------
  String _employeeName = "";
  String get employeeName => _employeeName;
  void changeemployeeName(val){
    _employeeName = val.toString();
    notifyListeners();
  }

  int? _indexSelectedEmployee;
  int? get indexSelectedEmployee => _indexSelectedEmployee;
  void changeIndexSelectedEmployee(val){
    _indexSelectedEmployee = val;
    notifyListeners();
  }

  void reset(){
    _client = "";
    _service = '';
    _assignmentIds= [];
    _projetName = '';
    _trainingName = "";
    _employeeName = "";
    notifyListeners();
  }

}
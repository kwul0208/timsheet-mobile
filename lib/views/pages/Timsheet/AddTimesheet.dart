import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Helper/Helper.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimeExistApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/ModeApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/ModeModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/assignment/AssignmentApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/assignment/AssignmentModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/employees/EmployeesApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/employees/EmployeesModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/project/ProjectApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/project/ProjectModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/training/TrainingApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/training/TrainingModel.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/Widget/CardAssignment.dart';

class addTimsheet extends StatefulWidget {
  const addTimsheet({super.key, required this.date});

  final String date;

  @override
  State<addTimsheet> createState() => _addTimsheetState();
}

class _addTimsheetState extends State<addTimsheet> {
  // view state
  bool _load = false;
  bool _showEmployees = false;
  bool _showClient = false;
  bool _showProject = false;
  bool _showTraining = false;


  late TimeOfDay _timeOfDayStart;
  late TimeOfDay _timeOfDayEnd;

  List options = [
    {'title': 'Prospecting', 'isActive': false},
    {'title': 'Daily Routine', 'isActive': false},
    {'title': 'Self Development', 'isActive': false},
    {'title': 'Client', 'isActive': false},
    {'title': 'Tax Office', 'isActive': false},
    {'title': 'Ishoma', 'isActive': false},
    {'title': 'Suport Service', 'isActive': false},
    {'title': 'Training', 'isActive': false},
    {'title': 'Project', 'isActive': false},
  ];


  // form
  TextEditingController dateinput = TextEditingController(); 
  TextEditingController timeStart = TextEditingController(); 
  TextEditingController timeEnd = TextEditingController(); 
  TextEditingController description = TextEditingController();
  TextEditingController client = TextEditingController();
  TextEditingController service = TextEditingController();
  TextEditingController projectNameC = TextEditingController();
  TextEditingController trainingNameC = TextEditingController();
  TextEditingController employeeNameC = TextEditingController();
  int id = 0; // mode
  // child mode
  int? projectIdMode;
  int? proposalIdMode;
  int? serviceIdMode;
  int? serviceUserIdMode;
  String? trainingIdMode;
  int? employeeIdMode;


  String mode = '';

  // data api
  List _timeX = [];

  // mode
  List<ModeModel>? _mode;
  Future<dynamic>? _futureMode;

    // list employees
  EmployeesModel? selectedUser;
  List<EmployeesModel> ? _employees;
  Future<dynamic>? _futureEmployees;

  // assignment
  AssignmentModel? selectedModel;
  List<AssignmentModel>? _assignment;
  Future<dynamic>? _futureAssignment;
  List _get = [];


  // projects
  List<ProjectModel>? _project;  
  Future<dynamic> ? _futureProject;

  // training
  List<TrainingModel>? _training;
  Future<dynamic>? _futureTraining;

  // employee
   List<EmployeesModel>? _allUsers;
  // This list holds the data for the list view
  List<EmployeesModel> _foundUsers = [];



  @override
  void initState(){
    super.initState();

    dateinput.text = widget.date;
    getTimeExist();
    _futureMode = getMode();
    _futureEmployees = getEmployees();

    _futureAssignment = getAssignment();
    _futureProject = getProject();
    _futureTraining = getTraining();

        // at the beginning, all users are shown
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<EmployeesModel>? results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _employees;
    } else {
      results = _employees!
          .where((user) =>
              user.fullname.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    print('objectxx');
          print(_employees);
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results!;
    });
  }


  //MODE
  changeState(item) {
    // print(item);
    setState(() {
      item['isActive'] = !item['isActive'];
    });
  
    for (var op in options) {
    if (op['title'] != item['title']) {
        setState(() {
          op['isActive'] = false;
        });
      }    }
  }

  customBoxDecoration(isActive) {
    return BoxDecoration(
      color: isActive ? Config().primary : Colors.white,
      border: Border(
        left: BorderSide(color: Colors.black12, width: 1.0),
        bottom: BorderSide(color: Colors.black12, width: 1.0),
        top: BorderSide(color: Colors.black12, width: 1.0),
        right: BorderSide(color: Colors.black12, width: 1.0)),
        borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
        var size, height, width;

    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Add Timesheet",
                style: TextStyle(color: Colors.black, fontSize: 18)),
            centerTitle: true,
            
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: dateinput, //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Enter Date" //label text of field
                        ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2022), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2024));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                           dateinput.text = formattedDate; //set output date to TextField value.
                        });
                        getAssignment();
                        getTraining();
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Flexible(
                          child: TextField(
                        controller: timeStart, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "Enter Time" //label text of field
                            ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if (pickedTime != null) {
                          _timeOfDayStart = pickedTime;

                          // formating dateime
                          var inputFormat = DateFormat('HH:mm');
                          var inputDate = inputFormat.parse(pickedTime.format(context)); // <-- dd/MM 24H format

                          var outputFormat = DateFormat('hh:mm a');
                          var outputDate = outputFormat.format(inputDate);
                          print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format

                          DateTime x = DateFormat.jm()
                                .parse(outputDate).add(Duration(minutes: 1));
                                print(x);

                            //output 14:59
                            String formattedTime = pickedTime.format(context);
                            String v_f_time = DateFormat('HH:mm').format(x);
                            print(formattedTime);
                            print(v_f_time);
                            // end formating datetime
                            
                            // validation
                            if (_timeX.contains(v_f_time)) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("time ${formattedTime} is not allowed"),
                              ));
                            }else{
                              setState(() {
                                // timeStart.text = pickedTime.format(context); //set the value of text field.
                                timeStart.text = formattedTime; //set the value of text field.
                              });
                            };
                          } else {
                            print("Time is not selected");
                          }
                        },
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          child: TextField(
                        controller: timeEnd, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "Enter Time" //label text of field
                            ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if (pickedTime != null) {
                            _timeOfDayEnd = pickedTime;

                                       // formating dateime
                            var inputFormat = DateFormat('HH:mm');
                            var inputDate = inputFormat.parse(pickedTime.format(context)); // <-- dd/MM 24H format

                            var outputFormat = DateFormat('hh:mm a');
                            var outputDate = outputFormat.format(inputDate);
                            print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format

                            DateTime x = DateFormat.jm()
                                .parse(outputDate).add(Duration(minutes: 1));
                                print(x);

                            //output 14:59
                            String formattedTime = pickedTime.format(context);
                            String v_f_time = DateFormat('HH:mm').format(x);
                            print(formattedTime);
                            print(v_f_time);
                            // end formating datetime
                            // validation
                            if (_timeX.contains(v_f_time)) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("time ${formattedTime} is not allowed"),
                              ));
                            }else{
                              setState(() {
                                // timeEnd.text = pickedTime.format(context); //set the value of text field.
                                timeEnd.text = formattedTime; //set the value of text field.
                              });
                            };

                          } else {
                            print("Time is not selected");
                          }
                        },
                      )),
                    ],
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    controller: description,
                    decoration: InputDecoration(
                      label: Text("Description"),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Config().line,)
                      )
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20,),
                  Text("Mode", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                  SizedBox(height: 10,),
                  // Wrap(
                  //   spacing: 10.0,
                  //   runSpacing: 20.0,
                  //   children: options
                  //   .map((option) =>  Container(
                  //   // margin: EdgeInsets.all(5),
                  //     decoration: customBoxDecoration(option['isActive']),
                  //     child: InkWell(
                  //       onTap: () {
                  //         changeState(option);
                  //       },
                  //       child: Container(
                  //         padding: const EdgeInsets.all(10),
                  //         child: Text('${option['title']}',
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.normal,
                  //           color: option['isActive']
                  //           ? Colors.white
                  //           : Colors.black87)
                  //         )
                  //       )
                  //     )
                  //   )
                  //   ).toList()
                  // ),
                  FutureBuilder(
                    future: _futureMode,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ---------- chargeable time ---------
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("${_mode![0].chargeable_time["name"]}", style: TextStyle(fontWeight: FontWeight.w500),),
                            ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, top: 10),
                                child: Text("${_mode![0].chargeable_time["sub"]['2']['name']}"),
                              ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['2']['sub']['1']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['2']['sub']['1']['id'], 
                                  groupValue: id, 
                                  onChanged: (val){
                                    setState(() {
                                      id = val;
                                      _showTraining = false;
                                      _showEmployees = false;
                                      _showClient = true;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['2']['sub']['2']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['2']['sub']['2']['id'], 
                                  groupValue: id, 
                                  onChanged: (val){
                                    setState(() {
                                      id = val;
                                      _showTraining = false;
                                      _showEmployees = false;
                                      _showClient = true;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['2']['sub']['3']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['2']['sub']['3']['id'], 
                                  groupValue: id, 
                                  onChanged: (val){
                                    setState(() {
                                      id = val;
                                      _showTraining = false;
                                      _showEmployees = false;
                                      _showClient = true;
                                    });
                                    print(val);
                                  }
                                ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text("${_mode![0].chargeable_time["sub"]['3']['name']}"),
                              ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['3']['sub']['1']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['3']['sub']['1']['id'], 
                                  groupValue: id, 
                                  onChanged: (val){
                                    setState(() {
                                      id = val;
                                      _showTraining = false;
                                      _showEmployees = false;
                                      _showClient = true;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['3']['sub']['2']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['3']['sub']['2']['id'], 
                                  groupValue: id, 
                                  onChanged: (val){
                                    setState(() {
                                      id = val;
                                      _showTraining = false;
                                      _showEmployees = false;
                                      _showClient = true;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['3']['sub']['3']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['3']['sub']['3']['id'], 
                                  groupValue: id, 
                                  onChanged: (val){
                                    setState(() {
                                      id = val;
                                      _showTraining = false;
                                      _showEmployees = false;
                                      _showClient = true;
                                    });
                                    print(val);
                                  }
                                ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text("${_mode![0].chargeable_time["sub"]['1']['name']}"),
                              ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['1']['sub']['1']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['1']['sub']['1']['id'], 
                                  groupValue: id, 
                                  onChanged: (val){
                                    setState(() {
                                      id = val;
                                      _showTraining = false;
                                      _showEmployees = false;
                                      _showClient = true;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['1']['sub']['2']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['1']['sub']['2']['id'], 
                                  groupValue: id, 
                                  onChanged: (val){
                                    setState(() {
                                      id = val;
                                      _showTraining = false;
                                      _showEmployees = false;
                                      _showClient = true;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['1']['sub']['3']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['1']['sub']['3']['id'], 
                                  groupValue: id, 
                                  onChanged: (val){
                                    setState(() {
                                      id = val;
                                      _showTraining = false;
                                      _showEmployees = false;
                                      _showClient = true;
                                    });
                                    print(val);
                                  }
                                ),
                            Divider(),
                            //----------- Prospecting -----------
                            SizedBox(height: 10),
                            RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("${_mode![0].prospecting["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              value: _mode![0].prospecting["id"], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showTraining = false;
                                  _showEmployees = false;
                                  _showClient = false;
                                  _showProject = false;
                                });
                                print(val);
                              }
                            ),
                            // ---------- Office Ad -----------
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("${_mode![0].office_admisitration["name"]}", style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].office_admisitration["sub"]['1']['name']}", style: TextStyle(color: Config().subText, fontSize: 13),),
                              value: _mode![0].office_admisitration["sub"]['1']['id'], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showTraining = false;
                                  _showEmployees = false;
                                  _showClient = false;
                                  _showProject = false;
                                });
                                print(val);
                              }
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].office_admisitration["sub"]['2']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].office_admisitration["sub"]['2']['id'], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showTraining = false;
                                  _showEmployees = false;
                                  _showClient = false;
                                  _showProject = false;
                                });
                                print(val);
                              }
                            ),
                            
                            Divider(),
                            //------------- BS Travel ----------
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("${_mode![0].business_travel["name"]}", style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].business_travel["sub"]['1']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].business_travel["sub"]['1']['id'], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showTraining = false;
                                  _showEmployees = false;
                                  _showClient = true;
                                });
                                print(val);
                              }
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].business_travel["sub"]['2']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].business_travel["sub"]['2']['id'], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showTraining = false;
                                  _showEmployees = false;
                                  _showClient = true;
                                });
                                print(val);
                              }
                            ),
                            
                            Divider(),
                            //------------ Ishoma -------------
                            RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("${_mode![0].ishoma["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              value: _mode![0].ishoma["id"], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showTraining = false;
                                  _showEmployees = false;
                                  _showClient = false;
                                  _showProject = false;
                                });
                                print(val);
                              }
                            ),
                            Divider(),
                            //------------ Suport service -------------
                            RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("${_mode![0].suport_service["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              value: _mode![0].suport_service["id"], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showTraining = false;
                                  _showEmployees = true;
                                  _showClient = false;
                                  _showProject = false;
                                });
                                print(val);
                              }
                            ),
                            _showEmployees == true ?
                            Row(
                              children: [
                                Flexible(
                                  child:  Consumer<TimesheetState>(
                                    builder: (context, data, _) {
                                      return TextField(
                                        readOnly: true,
                                        controller: employeeNameC..text = data.employeeName,
                                        decoration: InputDecoration(
                                          hintText: "Employees"
                                        ),

                                      );
                                    }
                                  )
                                ),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _foundUsers = _employees!;
                                    });
                                    showModalBottomSheet<void>(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                      ),
                                      context: context,
                                      isScrollControlled: true, // set this to true
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState ) {
                                            return DraggableScrollableSheet(
                                              expand: false,
                                              builder: (context, scrollController) {
                                                return Column(
                                                  children: <Widget>[
                                                    // Put all heading in column.
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Align(
                                                          alignment: Alignment.topCenter,
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(vertical: 8),
                                                            height: 8.0,
                                                            width: 70.0,
                                                            decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10.0)),
                                                          ),
                                                        ),
                                                        SizedBox(height: 16),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 24),
                                                          child: Text('Select Employee', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 24),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              SizedBox(height: 20.0),
                                                              TextField(
                                                                onChanged: (value) => _runFilter(value),
                                                                decoration: const InputDecoration(
                                                                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 16),
                                                      ],
                                                    ),
                                                    // Wrap your DaysList in Expanded and provide scrollController to it
                                                    Expanded(child: _foundUsers.isNotEmpty
                                                      ? ListView.builder(
                                                        controller: scrollController,
                                                          itemCount: _foundUsers.length,
                                                          itemBuilder: (context, index) => Card(
                                                            key: ValueKey(_foundUsers[index].id),
                                                            color: Config().primary,
                                                            elevation: 4,
                                                            // margin: const EdgeInsets.symmetric(vertical: 10),
                                                            child: ListTile(
                                                              title: Text(_foundUsers[index].fullname),
                                                              onTap: (){
                                                                employeeIdMode = _foundUsers[index].id;
                                                                Provider.of<TimesheetState>(context, listen: false).changeemployeeName(_foundUsers[index].fullname);
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ),
                                                        )
                                                      : const Text(
                                                          'No results found',
                                                          style: TextStyle(fontSize: 24),
                                                        ),),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Icon(Icons.assignment, color: Config().redAccent, size: 30,),
                                  ),
                                )
                              ],
                            ) : SizedBox(),
                            // FutureBuilder(
                            //   future: _futureEmployees,
                            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                            //     if (snapshot.connectionState == ConnectionState.done) {
                            //       return Padding(
                            //         padding: const EdgeInsets.only(left: 10),
                            //         child: _showEmployees == true ? DropdownButton<EmployeesModel>(
                            //           hint: Text("-- Choose --"),
                            //           value: selectedUser,
                            //           onChanged: (EmployeesModel? newValue) {
                            //             setState(() {
                            //               selectedUser = newValue;
                            //             });
                            //           },
                            //           items: _employees?.map((EmployeesModel user) {
                            //             return new DropdownMenuItem<EmployeesModel>(
                            //               value: user,
                            //               child: Text(
                            //                 user.fullname,
                            //                 style: new TextStyle(color: Colors.black),
                            //               ),
                            //             );
                            //           }).toList(),
                            //         ) : SizedBox(),
                            //       );
                            //     }else{
                            //       return SizedBox();
                            //     }
                            //   }
                            // ),

                            Divider(),
                            //------------ Training -------------
                            RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("${_mode![0].training["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              value: _mode![0].training["id"], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showTraining = true;
                                  _showEmployees = false;
                                  _showClient = false;
                                  _showProject = false;
                                });
                                print(val);
                              }
                            ),
                            _showTraining == true ?
                            Row(
                              children: [
                                Flexible(
                                  child:  Consumer<TimesheetState>(
                                    builder: (context, data, _) {
                                      return TextField(
                                        readOnly: true,
                                        controller: trainingNameC..text = data.trainingName,
                                        decoration: InputDecoration(
                                          hintText: "Training"
                                        ),

                                      );
                                    }
                                  )
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet<void>(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                      ),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Text("Your Training", style: TextStyle(fontSize: 24),),
                                                    Divider(),
                                                    Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: ListView.builder(
                                                        physics: NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: _training?.length,
                                                        itemBuilder: ((context, i){
                                                          return Ink(
                                                            child: ListTile(
                                                              title: Text("${_training![i].training_name}"),
                                                              onTap: (){
                                                                trainingIdMode = _training![i].id.toString();
                                                                Provider.of<TimesheetState>(context, listen: false).changeTrainingName(_training![i].training_name);
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Icon(Icons.assignment, color: Config().redAccent, size: 30,),
                                  ),
                                )
                              ],
                            ) : SizedBox(),
                            Divider(),
                            // ---------- Development -----------
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("${_mode![0].development["name"]}", style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].development["sub"]['1']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].development["sub"]['1']['id'], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showTraining = false;
                                  _showEmployees = false;
                                  _showClient = false;
                                  _showProject = true;
                                });
                                Provider.of<TimesheetState>(context, listen: false).changeProjectName('');
                                print(val);
                              }
                            ),
                            _showProject == true ?
                            Row(
                              children: [
                                Flexible(
                                  child:  Consumer<TimesheetState>(
                                    builder: (context, data, _) {
                                      return TextField(
                                        readOnly: true,
                                        controller: projectNameC..text = data.projectName,
                                        decoration: InputDecoration(
                                          hintText: "project"
                                        ),

                                      );
                                    }
                                  )
                                ),
                                GestureDetector(
                                  onTap: (){
                                    print('woy');
                                    showModalBottomSheet<void>(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                      ),
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return DraggableScrollableSheet(
                                              expand: false,
                                              builder: (context, scrollController) {
                                                return Column(
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.topCenter,
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(vertical: 8),
                                                            height: 8.0,
                                                            width: 70.0,
                                                            decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10.0)),
                                                          ),
                                                        ),
                                                        SizedBox(height: 16),
                                                        Padding(
                                                          padding: EdgeInsets.only(bottom: 20),
                                                          child: Text('Select project', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                        ),
                                                      ],
                                                    ),
                                                    
                                                    Expanded(
                                                      child: ListView.builder(
                                                        controller: scrollController,
                                                        // physics: NeverScrollableScrollPhysics(),
                                                        // shrinkWrap: true,
                                                        itemCount: _project?.length,
                                                        itemBuilder: ((context, i){
                                                          return Ink(
                                                            child: ListTile(
                                                              title: Text("${_project![i].project_name}"),
                                                              onTap: (){
                                                                projectIdMode = _project![i].id;
                                                                Provider.of<TimesheetState>(context, listen: false).changeProjectName(_project![i].project_name!);
                                                                Navigator.pop(context);
                                                              },
                                                               shape: Border.all(color: Config().line, width: 1),

                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            );
                                          }
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Icon(Icons.assignment, color: Config().redAccent, size: 30,),
                                  ),
                                )
                              ],
                            ) : SizedBox(),
                            RadioListTile(
                              title: Text("${_mode![0].development["sub"]['2']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].development["sub"]['2']['id'], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showTraining = false;
                                  _showEmployees = false;
                                  _showClient = false;
                                  _showProject = false;
                                });
                                print(val);
                              }
                            ),
                            Divider(),

                            // Client
                            //  _showClient == true ? Padding(
                            //   padding: const EdgeInsets.only(left: 10),
                            //   child: Text("Client", style: TextStyle(fontWeight: FontWeight.w500)),
                            // ) : SizedBox(),

                            _showClient == true ? Column(
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                //   child: DropdownSearch<dynamic>(
                                //     showSelectedItems: false,
                                //     showClearButton: true,
                                //     dropdownSearchDecoration: InputDecoration(
                                //       labelText: "Search",
                                //       hintText: "Search Name",
                                //     ),
                                //     //have two mode: menu mode and dialog mode
                                //     mode: Mode.DIALOG,
                                //     //if you want show search box
                                //     showSearchBox: true,
                                //     //get data from the internet
                                //     onFind: (text) async {
                                //       final storage = new FlutterSecureStorage();
                                //       var employees_id = await storage.read(key: 'employees_id');

                                //       var headers = {
                                //         'Content-Type': 'application/json',
                                //       };
                                //       var request = http.Request(
                                //           'GET',
                                //           Uri.parse(
                                //               '$baseUrl/mucnet_api/api/assignment-consultant'));

                                //         request.body = json.encode({
                                //           "date": "${dateinput.text}",
                                //           "employees_id": employees_id
                                //         });

                                //       request.headers.addAll(headers);

                                //       http.StreamedResponse response = await request.send();

                                //       if (response.statusCode == 200) {
                                //         var x = await response.stream.bytesToString();
                                //         List data = jsonDecode(x);

                                //         setState(() {
                                //           _get = data;
                                //         });
                                //       }else{
                                //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //           content: Text("failed!, ${response.reasonPhrase}"),
                                //         ));
                                //       }

                                //       return _get as List<dynamic>;
                                //     },

                                //     //what do you want anfter item clicked
                                //     onChanged: (value) {

                                //      print(value);

                                      
                                //     },

                                //     //this data appear in dropdown after clicked
                                //     itemAsString: (item) => item['companies_name'],
                                //   ),
                                // ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Consumer<TimesheetState>(
                                        builder: (context, data, _) {
                                          // -- initial after state change --
                                         
                                          if(data.assignmentIds.length != 0){
                                            proposalIdMode = data.assignmentIds[0];
                                            serviceIdMode = data.assignmentIds[1];
                                            serviceUserIdMode = data.assignmentIds[2];
                                          }

                                          return TextField(
                                            readOnly: true,
                                            controller: client..text = data.client,
                                            decoration: InputDecoration(
                                              hintText: "Client"
                                            ),
                                            
                                          );
                                        }
                                      )
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        print('woy');
                                        showModalBottomSheet<void>(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                          ),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 10),
                                                        Text("Your Assignment", style: TextStyle(fontSize: 24),),
                                                        Divider(),
                                                        Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: ListView.builder(
                                                            physics: NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: _assignment?.length,
                                                            itemBuilder: ((context, i){
                                                              return CardAssignment(width: width, companies_name: _assignment![i].companies_name, name_service: _assignment![i].service_name, year: _assignment![i].service_period, ope: _assignment![i].ope, assign_numbber: _assignment![i].assignment_number, scope: _assignment![i].service_scope, proposal_id: _assignment![i].proposal_id, service_id: _assignment![i].services_id, serviceused_id: _assignment![i].serviceused_id,);
                                                            }),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            );
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: Icon(Icons.assignment, color: Config().redAccent, size: 30,),
                                      ),
                                    )
                                  ],
                                ),
                                Consumer<TimesheetState>(
                                  builder: (context, data, _) {
                                    return TextField(
                                      readOnly: true,
                                      controller: service..text = data.service,
                                      decoration: InputDecoration(
                                        hintText: "Service"
                                      ),
                                    );
                                  }
                                )

                              ],
                            ) : SizedBox(),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Config().primary,
                                minimumSize: const Size.fromHeight(50), // NEW
                              ),
                              onPressed: (){
                                // return null;
                                setState(() {
                                  _load = true;
                                });

                                // -- try
                                //  cek first isi 
                                if (_timeX.isEmpty) {
                                  postTimesheet().then((value) {
                                    setState(() {
                                      _load= false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("${value['message']}"),
                                    ));
                                    value['status'] == true ? Navigator.pop(context, dateinput.text) : null;
                                  });
                                }else{
                                  print('ada');
                                  String last_timeX = _timeX.last;
                                  int idx = last_timeX.indexOf(":");
                                  List parts = [last_timeX.substring(0,idx).trim(), last_timeX.substring(idx+1).trim()];
                                  var V_end_time = TimeOfDay(hour: int.parse("${parts[0]}"), minute: int.parse("${parts[1]}"));
                                  
                                  // check start time nya kurang dari time akhir input ga, kalo kurang dicek dulu biar  input end time nya ga lebih dari V_end_time(inputan terakhir)
                                  bool check_start_time = Helper().isValidTimeRange(_timeOfDayStart, V_end_time);
                                  if(check_start_time == true){
                                    // check end time nya kalo lebih ya ga valid
                                    bool check_end_time = Helper().isValidTimeRange(_timeOfDayEnd, V_end_time);
                                    if (check_end_time == false ) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text("Time Not Valid!"),
                                      ));
                                    }else{
                                      print('valid1');
                                      postTimesheet().then((value) {
                                        setState(() {
                                          _load= false;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text("${value['message']}"),
                                        ));
                                        value['status'] == true ? Navigator.pop(context, dateinput.text) : null;
                                      });
                                    }
                                  }else{
                                    print('valid2');
                                    postTimesheet().then((value) {
                                      setState(() {
                                        _load= false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text("${value['message']}"),
                                      ));
                                      value['status'] == true ? Navigator.pop(context, dateinput.text) : null;
                                    });
                                  }
                                }                    
                                            // -- end  
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ],
                        );
                      }else{
                        return CircularProgressIndicator();
                      }
                    }
                  )
                ],
              ),
            ),
          ),
        ),
        _load == true ? Container(
          width: width,
          height: height,
          color: Color.fromARGB(78, 0, 0, 0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) : SizedBox()
      ],
    );
  }

  // API
  String baseUrl = Config().url;

  Future postTimesheet()async{
    if(timeStart.text.isEmpty|| timeEnd.text.isEmpty || dateinput.text.isEmpty || description.text.isEmpty || id == 0){
      return {"status": false, "message": "Your form is not complete!"};
    }

    final storage = new FlutterSecureStorage();
    var employees_id = await storage.read(key: 'employees_id');
    
    // print({
    //   "timestart": "${timeStart.text}",
    //   "timefinish": "${timeEnd.text}",
    //   "date": "${dateinput.text}",
    //   "is_overtime": "0",
    //   "input_from": "pms",
    //   "description": "${description.text}",
    //   "employees_id": "575",
    //   "tmode_id": id
    // });
    // return {"status": true, "message": "success"};
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('${baseUrl}/mucnet_api/api/timesheet/update'));
    // -- suport service --
    if(id == 8){
      print('suport_service');
      request.body = json.encode({
        "timestart": "${timeStart.text}",
        "timefinish": "${timeEnd.text}",
        "date": "${dateinput.text}",
        "is_overtime": "0",
        "input_from": "pms",
        "description": "${description.text}",
        "employees_id": "$employees_id",
        "tmode_id": id,
        "support_employees_id": employeeIdMode
      });
    
    // -- project --
    }else if(id == 14){
      print({"project_id": projectIdMode});
      request.body = json.encode({
        "timestart": "${timeStart.text}",
        "timefinish": "${timeEnd.text}",
        "date": "${dateinput.text}",
        "is_overtime": "0",
        "input_from": "pms",
        "description": "${description.text}",
        "employees_id": "$employees_id",
        "tmode_id": id,
        "project_id": projectIdMode
      });

    // -- chargeable time --
    }else if(id == 23 || id == 22 || id == 19 || id == 15 || id == 17 ||id == 16 || id == 21 || id == 20 || id == 18){
      request.body = json.encode({
        "timestart": "${timeStart.text}",
        "timefinish": "${timeEnd.text}",
        "date": "${dateinput.text}",
        "is_overtime": "0",
        "input_from": "pms",
        "description": "${description.text}",
        "employees_id": "$employees_id",
        "tmode_id": id,
        "proposal_id": proposalIdMode,
        "services_id": serviceIdMode,
        "serviceused_id": serviceUserIdMode
      });

    // -- training --
    }else if(id == 9){
     print({"training_id": trainingIdMode});
      request.body = json.encode({
        "timestart": "${timeStart.text}",
        "timefinish": "${timeEnd.text}",
        "date": "${dateinput.text}",
        "is_overtime": "0",
        "input_from": "pms",
        "description": "${description.text}",
        "employees_id": "$employees_id",
        "tmode_id": id,
        "training_id": trainingIdMode
      }); 
    // -- umum --
    }else{
      print('umum');
      request.body = json.encode({
        "timestart": "${timeStart.text}",
        "timefinish": "${timeEnd.text}",
        "date": "${dateinput.text}",
        "is_overtime": "0",
        "input_from": "pms",
        "description": "${description.text}",
        "employees_id": "$employees_id",
        "tmode_id": id
      });
    }

    // return {"status": false, "message": "test"};
    
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    // print(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      var x = await response.stream.bytesToString();
      print(x);
      Map data = jsonDecode(x);
      print(data);

      if (data['status'] == "success") {
        return {"status": true, "message": "success"};
      }else{
          return {"status": false, "message": "$data"};
      }
    }
    else {
            var x = await response.stream.bytesToString();
      print(x);
      return {"status": false, "message": "${response.reasonPhrase}"};
    }
  }

  getTimeExist() async{
    final storage = new FlutterSecureStorage();
    var employees_id = await storage.read(key: 'employees_id');
    _timeX = await TimeExistapi.getTime(context, widget.date, employees_id!);
  }

  getMode()async{
    _mode = await ModeApi.getDataMode(context);

  }

  
  getEmployees()async{
    _employees = await EmployeesApi.getEmployees(context);
    _foundUsers = _employees!;
    // selectedUser=_employees![0];
  }

  getAssignment()async{
    _assignment = await AssignmentApi.getDataAssignment(context, dateinput.text);
  }

  getProject()async{
    _project = await ProjectApi.getDataProject(context);
  }

  getTraining()async{
    _training = await TrainingApi.getDataProject(context, dateinput.text);
  }
}



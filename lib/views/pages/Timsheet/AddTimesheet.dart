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
  const addTimsheet({super.key, required this.date, this.is_consultant, this.work_from});

  final String date;
  final String? is_consultant;
  final String? work_from;

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
  // child mode state
  bool _showChildCT = false;
  bool _showChildOA = false;
  bool _showChildBT = false;
  bool _showChildDev = false;


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

  // default form
  TimeOfDay _Tstart = TimeOfDay.now();
  TimeOfDay _Tend = TimeOfDay.now();

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
  List<AssignmentModel> _foundAssignment = [];


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
    
    super.initState();
  }

  // Employees search
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

  // assignment search
  void _runFilterAssignment(String enteredKeyword) {
    List<AssignmentModel>? results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _assignment;
    } else {
      results = _assignment!
          .where((user) =>
              user.companies_name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    print('objectxx');
          print(_assignment);
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundAssignment = results!;
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
    DateTime dt = DateTime.parse("${dateinput.text}");
    String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
    // print(DateFormat('EEEE').format(dt));
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
                  // TextField(
                  //   controller: dateinput, //editing controller of this TextField
                  //   decoration: InputDecoration(
                  //       icon: Icon(Icons.calendar_today), //icon of text field
                  //       labelText: "Enter Date" //label text of field
                  //       ),
                  //   readOnly:
                  //       true, //set it true, so that user will not able to edit text
                  //   onTap: () async {
                  //     DateTime? pickedDate = await showDatePicker(
                  //         context: context,
                  //         initialDate: DateTime.now(),
                  //         firstDate: DateTime(
                  //             2022), //DateTime.now() - not to allow to choose before today.
                  //         lastDate: DateTime(2024));

                  //     if (pickedDate != null) {
                  //       print(
                  //           pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  //       String formattedDate =
                  //           DateFormat('yyyy-MM-dd').format(pickedDate);
                  //       print(
                  //           formattedDate); //formatted date output using intl package =>  2021-03-16
                  //       //you can implement different kind of Date Format here according to your requirement

                  //       setState(() {
                  //          dateinput.text = formattedDate; //set output date to TextField value.
                  //       });
                  //       getAssignment();
                  //       getTraining();
                  //     } else {
                  //       print("Date is not selected");
                  //     }
                  //   },
                  // ),
                  Container(
                    // width: width/1.8,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("${DateFormat('EEEE').format(dt)}, ${formattedDate}", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: timeStart, //editing controller of this TextField
                    decoration: InputDecoration(
                        labelText: "Time Start" //label text of field
                        ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: _Tstart,
                        context: context,
                        initialEntryMode: TimePickerEntryMode.input,
                        builder: (context, child){
                          return Theme(
                            data: ThemeData.light().copyWith(
                              
                              colorScheme: ColorScheme.light(
                                // change the border color
                                primary: Config().primary,
                                // change the text color
                                onSurface: Config().primary,
                                
                              ),
                              
                              // button colors 
                              buttonTheme: ButtonThemeData(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.green,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        }
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
                          var parts = formattedTime.split(':');
                          // -- not first input timesheet
                          if(_timeX.isNotEmpty){
                            var check_hour =  Helper().getDurationRangeHour(timeStart.text, timeEnd.text);
                            if(check_hour <= 1.0){
                              String timeString = formattedTime;
                              DateTime time = DateTime.parse("2023-02-16 $timeString:00"); // parse time string to DateTime object
                              DateTime nextHour = time.add(Duration(hours: 1)); // add one hour to the time
                              String nextHourString = "${nextHour.hour.toString().padLeft(2, '0')}:${nextHour.minute.toString().padLeft(2, '0')}"; // convert DateTime to string in "hh:mm" format
                              var parts2 = nextHourString.split(':');
                              

                              setState(() {
                                // timeStart.text = pickedTime.format(context); //set the value of text field.
                                timeStart.text = formattedTime; //set the value of text field.
                                timeEnd.text = "${nextHourString}";
                                _Tstart = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
                                _Tend = TimeOfDay(hour: int.parse(parts2[0]), minute: int.parse(parts2[1]));
                              });
                            }else{
                              setState(() {
                                timeStart.text = formattedTime;
                                _Tstart = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
                              });
                            }
                          }else{
                            if(timeEnd.text.isEmpty){
                              String timeString = formattedTime;
                              DateTime time = DateTime.parse("2023-02-16 $timeString:00"); // parse time string to DateTime object
                              DateTime nextHour = time.add(Duration(hours: 1)); // add one hour to the time
                              String nextHourString = "${nextHour.hour.toString().padLeft(2, '0')}:${nextHour.minute.toString().padLeft(2, '0')}"; // convert DateTime to string in "hh:mm" format
                              var parts2 = nextHourString.split(':');
                              

                              setState(() {
                                // timeStart.text = pickedTime.format(context); //set the value of text field.
                                timeStart.text = formattedTime; //set the value of text field.
                                timeEnd.text = "${nextHourString}";
                                _Tstart = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
                                _Tend = TimeOfDay(hour: int.parse(parts2[0]), minute: int.parse(parts2[1]));
                              });
                            }else{
                              var check_hour =  Helper().getDurationRangeHour(timeStart.text, timeEnd.text);
                              if(check_hour <= 1.0){
                                String timeString = formattedTime;
                                DateTime time = DateTime.parse("2023-02-16 $timeString:00"); // parse time string to DateTime object
                                DateTime nextHour = time.add(Duration(hours: 1)); // add one hour to the time
                                String nextHourString = "${nextHour.hour.toString().padLeft(2, '0')}:${nextHour.minute.toString().padLeft(2, '0')}"; // convert DateTime to string in "hh:mm" format
                                var parts2 = nextHourString.split(':');
                                

                                setState(() {
                                  // timeStart.text = pickedTime.format(context); //set the value of text field.
                                  timeStart.text = formattedTime; //set the value of text field.
                                  timeEnd.text = "${nextHourString}";
                                  _Tstart = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
                                  _Tend = TimeOfDay(hour: int.parse(parts2[0]), minute: int.parse(parts2[1]));
                                });
                              }else{
                                setState(() {
                                  timeStart.text = formattedTime;
                                  _Tstart = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
                                });
                              }
                            }
                          }
                          
                        };
                      } else {
                        print("Time is not selected");
                      }
                    },
                  ),
                  TextField(
                    controller: timeEnd, //editing controller of this TextField
                    decoration: InputDecoration(
                      labelText: "Time Finish" //label text of field
                    ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: _Tend,
                        context: context,
                        initialEntryMode: TimePickerEntryMode.input,
                        builder: (context, child){
                          return Theme(
                            data: ThemeData.light().copyWith(
                              
                              colorScheme: ColorScheme.light(
                                // change the border color
                                primary: Config().primary,
                                // change the text color
                                onSurface: Config().primary,
                                
                              ),
                              
                              // button colors 
                              buttonTheme: ButtonThemeData(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.green,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        }
                      );

                      if (pickedTime != null) {
                        _timeOfDayEnd = pickedTime;

                                   // formating dateime
                        var inputFormat = DateFormat('HH:mm');
                        var inputDate = inputFormat.parse(pickedTime.format(context)); // <-- dd/MM 24H format

                        var outputFormat = DateFormat('hh:mm a');
                        var outputDate = outputFormat.format(inputDate);
                        print('outputDate'); // 12/31/2000 11:59 PM <-- MM/dd 12H format
                        print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format

                        DateTime x = DateFormat.jm()
                            .parse(outputDate).subtract(Duration(minutes: 1));
                            print(x);

                        //output 14:59
                        String formattedTime = pickedTime.format(context);
                        String v_f_time = DateFormat('HH:mm').format(x);
                        // print(formattedTime);
                        // print(v_f_time);
                        // end formating datetime
                        // validation
                        if (_timeX.contains(v_f_time)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("time ${formattedTime} is not allowed"),
                          ));
                        }else{
                          var parts2 = formattedTime.split(':');
                          setState(() {
                            // timeEnd.text = pickedTime.format(context); //set the value of text field.
                            timeEnd.text = formattedTime; //set the value of text field.
                            _Tend = TimeOfDay(hour: int.parse(parts2[0]), minute: int.parse(parts2[1]));
                          });
                        };

                      } else {
                        print("Time is not selected");
                      }
                    },
                  ),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //         child: TextField(
                  //       controller: timeStart, //editing controller of this TextField
                  //       decoration: InputDecoration(
                  //           icon: Icon(Icons.timer), //icon of text field
                  //           labelText: "Enter Time" //label text of field
                  //           ),
                  //       readOnly:
                  //           true, //set it true, so that user will not able to edit text
                  //       onTap: () async {
                  //         TimeOfDay? pickedTime = await showTimePicker(
                  //           initialTime: TimeOfDay.now(),
                  //           context: context,
                  //         );

                  //         if (pickedTime != null) {
                  //         _timeOfDayStart = pickedTime;

                  //         // formating dateime
                  //         var inputFormat = DateFormat('HH:mm');
                  //         var inputDate = inputFormat.parse(pickedTime.format(context)); // <-- dd/MM 24H format

                  //         var outputFormat = DateFormat('hh:mm a');
                  //         var outputDate = outputFormat.format(inputDate);
                  //         print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format

                  //         DateTime x = DateFormat.jm()
                  //               .parse(outputDate).add(Duration(minutes: 1));
                  //               print(x);

                  //           //output 14:59
                  //           String formattedTime = pickedTime.format(context);
                  //           String v_f_time = DateFormat('HH:mm').format(x);
                  //           print(formattedTime);
                  //           print(v_f_time);
                  //           // end formating datetime
                            
                  //           // validation
                  //           if (_timeX.contains(v_f_time)) {
                  //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //               content: Text("time ${formattedTime} is not allowed"),
                  //             ));
                  //           }else{
                  //             setState(() {
                  //               // timeStart.text = pickedTime.format(context); //set the value of text field.
                  //               timeStart.text = formattedTime; //set the value of text field.
                  //             });
                  //           };
                  //         } else {
                  //           print("Time is not selected");
                  //         }
                  //       },
                  //     )),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     Flexible(
                  //         child: TextField(
                  //       controller: timeEnd, //editing controller of this TextField
                  //       decoration: InputDecoration(
                  //           icon: Icon(Icons.timer), //icon of text field
                  //           labelText: "Enter Time" //label text of field
                  //           ),
                  //       readOnly:
                  //           true, //set it true, so that user will not able to edit text
                  //       onTap: () async {
                  //         TimeOfDay? pickedTime = await showTimePicker(
                  //           initialTime: TimeOfDay.now(),
                  //           context: context,
                  //         );

                  //         if (pickedTime != null) {
                  //           _timeOfDayEnd = pickedTime;

                  //                      // formating dateime
                  //           var inputFormat = DateFormat('HH:mm');
                  //           var inputDate = inputFormat.parse(pickedTime.format(context)); // <-- dd/MM 24H format

                  //           var outputFormat = DateFormat('hh:mm a');
                  //           var outputDate = outputFormat.format(inputDate);
                  //           print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format

                  //           DateTime x = DateFormat.jm()
                  //               .parse(outputDate).add(Duration(minutes: 1));
                  //               print(x);

                  //           //output 14:59
                  //           String formattedTime = pickedTime.format(context);
                  //           String v_f_time = DateFormat('HH:mm').format(x);
                  //           print(formattedTime);
                  //           print(v_f_time);
                  //           // end formating datetime
                  //           // validation
                  //           if (_timeX.contains(v_f_time)) {
                  //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //               content: Text("time ${formattedTime} is not allowed"),
                  //             ));
                  //           }else{
                  //             setState(() {
                  //               // timeEnd.text = pickedTime.format(context); //set the value of text field.
                  //               timeEnd.text = formattedTime; //set the value of text field.
                  //             });
                  //           };

                  //         } else {
                  //           print("Time is not selected");
                  //         }
                  //       },
                  //     )),
                  //   ],
                  // ),
                  // SizedBox(height: 30,),
                  TextFormField(
                    controller: description,
                    decoration: InputDecoration(
                      label: Text("Description"),
                      alignLabelWithHint: true
                      // border: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Config().line,)
                      // )
                    ),
                    maxLines: 8,
                  ),
                  SizedBox(height: 20,),
                  Text("Mode", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                  SizedBox(height: 10,),
                  FutureBuilder(
                    future: _futureMode,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ---------- chargeable time ---------
                            widget.is_consultant == "1" ?
                            TextFormField(
                              onTap: (){
                                setState(() {
                                  _showChildCT = !_showChildCT;
                                  _showChildBT = false;
                                  _showChildDev = false;
                                  _showChildOA = false;
                                  _showEmployees = false;
                                  _showTraining = false;
                                  _showProject = false;
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                focusedBorder:  UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),  
                                suffixIcon: IconButton(
                                  onPressed: (){},
                                  icon: id == 23 || id == 22 || id == 19 || id == 15 || id == 17 ||id == 16 || id == 21 || id == 20 || id == 18 ? Icon(Icons.check, color: Config().primary,) : SizedBox(),
                                ),
                              ),
                              controller: TextEditingController(text: "${_mode![0].chargeable_time["name"]}"),
                            ) : SizedBox(),
                            SizedBox(height: 20),
                            _showChildCT == true ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${_mode![0].chargeable_time["sub"]['2']['name']}", style: TextStyle(color: Config().primary, fontWeight: FontWeight.w500, fontSize: 16),),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text("${_mode![0].chargeable_time["sub"]['2']['sub']['1']['name']}", style: TextStyle(fontSize: 14, ),),
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
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text("${_mode![0].chargeable_time["sub"]['2']['sub']['2']['name']}", style: TextStyle(fontSize: 14),),
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
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text("${_mode![0].chargeable_time["sub"]['2']['sub']['3']['name']}", style: TextStyle(fontSize: 14),),
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
                              Text("${_mode![0].chargeable_time["sub"]['3']['name']}", style: TextStyle(color: Config().primary, fontWeight: FontWeight.w500, fontSize: 16),),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text("${_mode![0].chargeable_time["sub"]['3']['sub']['1']['name']}", style: TextStyle(fontSize: 14),),
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
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text("${_mode![0].chargeable_time["sub"]['3']['sub']['2']['name']}", style: TextStyle(fontSize: 14),),
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
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text("${_mode![0].chargeable_time["sub"]['3']['sub']['3']['name']}", style: TextStyle(fontSize: 14),),
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
                              Text("${_mode![0].chargeable_time["sub"]['1']['name']}",style: TextStyle(color: Config().primary, fontWeight: FontWeight.w500, fontSize: 16),),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text("${_mode![0].chargeable_time["sub"]['1']['sub']['1']['name']}", style: TextStyle(fontSize: 14),),
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
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text("${_mode![0].chargeable_time["sub"]['1']['sub']['2']['name']}", style: TextStyle(fontSize: 14),),
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
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text("${_mode![0].chargeable_time["sub"]['1']['sub']['3']['name']}", style: TextStyle(fontSize: 14),),
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
                              ],
                            ) : SizedBox(),
                            
                            //----------- Prospecting -----------
                            // RadioListTile(
                            //   contentPadding: EdgeInsets.all(0),
                            //   title: Text("${_mode![0].prospecting["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                            //   value: _mode![0].prospecting["id"], 
                            //   groupValue: id, 
                            //   onChanged: (val){
                            //     setState(() {
                            //       id = val;
                            //       _showTraining = false;
                            //       _showEmployees = false;
                            //       _showClient = false;
                            //       _showProject = false;
                            //     });
                            //     print(val);
                            //   }
                            // ),
                            TextField(
                              onTap: (){
                                setState(() {
                                  id = _mode![0].prospecting["id"];
                                  _showTraining = false;
                                  _showEmployees = false;
                                  _showClient = false;
                                  _showProject = false;

                                  _showChildBT = false;
                                  _showChildCT = false;
                                  _showChildDev = false;
                                  _showChildOA = false;
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                focusedBorder:  UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: (){},
                                  icon: id == 2 ? Icon(Icons.check, color: Config().primary,) : SizedBox(),
                                ),
                              ),
                              controller: TextEditingController(text: "${_mode![0].prospecting["name"]}"),
                            ),
                            SizedBox(height: 10),
                            // ---------- Office Ad -----------
                            TextField(
                              onTap: (){
                                setState(() {
                                  _showChildOA = !_showChildOA;
                                  _showChildBT = false;
                                  _showChildCT = false;
                                  _showChildDev = false;
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                focusedBorder:  UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: (){},
                                  icon: id == 13 || id == 28 ? Icon(Icons.check, color: Config().primary,) : SizedBox(),
                                ),
                              ),
                              controller: TextEditingController(text: "${_mode![0].office_admisitration["name"]}"),
                            ),
                            _showChildOA == true ? Column(
                              children: [
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text("${_mode![0].office_admisitration["sub"]['1']['name']}", style: TextStyle(fontSize: 14),),
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
                                  contentPadding: EdgeInsets.only(left: 0),
                                  title: Text("${_mode![0].office_admisitration["sub"]['2']['name']}", style: TextStyle(fontSize: 14)),
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
                              ],
                            ) : SizedBox(),
                            SizedBox(height: 10),
                            //------------- BS Travel ----------
                            TextField(
                              onTap: (){
                                setState(() {
                                  _showChildBT = !_showChildBT;
                                  _showChildCT = false;
                                  _showChildDev = false;
                                  _showChildOA = false;
                                  _showEmployees = false;
                                  _showTraining = false;
                                  _showProject = false;
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                focusedBorder:  UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: (){},
                                  icon: id == 24 || id == 25 ? Icon(Icons.check, color: Config().primary,) : SizedBox(),
                                ),
                              ),
                              controller: TextEditingController(text: "${_mode![0].business_travel["name"]}"),
                            ),
                            _showChildBT == true ? Column(
                              children: [
                                RadioListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text("${_mode![0].business_travel["sub"]['1']['name']}", style: TextStyle(fontSize: 14)),
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
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text("${_mode![0].business_travel["sub"]['2']['name']}", style: TextStyle(fontSize: 14)),
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
                              ],
                            ) : SizedBox(),
                            //------------ Ishoma -------------
                            // RadioListTile(
                            //   contentPadding: EdgeInsets.all(0),
                            //   title: Text("${_mode![0].ishoma["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                            //   value: _mode![0].ishoma["id"], 
                            //   groupValue: id, 
                            //   onChanged: (val){
                            //     setState(() {
                            //       id = val;
                            //       _showTraining = false;
                            //       _showEmployees = false;
                            //       _showClient = false;
                            //       _showProject = false;
                            //     });
                            //     print(val);
                            //   }
                            // ),
                            SizedBox(height: 10),
                            widget.work_from == "office" ? 
                              TextField(
                                onTap: (){
                                  setState(() {
                                    id = _mode![0].ishoma["id"];
                                    _showTraining = false;
                                    _showEmployees = false;
                                    _showClient = false;
                                    _showProject = false;

                                    _showChildBT = false;
                                    _showChildCT = false;
                                    _showChildDev = false;
                                    _showChildOA = false;
                                  });
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                  focusedBorder:  UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: (){},
                                    icon: id == 6 ? Icon(Icons.check) : SizedBox(),
                                  ),
                                ),
                                controller: TextEditingController(text: "${_mode![0].ishoma["name"]}"),
                              ) : SizedBox(),
                            //------------ Suport service -------------
                            // RadioListTile(
                            //   contentPadding: EdgeInsets.all(0),
                            //   title: Text("${_mode![0].suport_service["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                            //   value: _mode![0].suport_service["id"], 
                            //   groupValue: id, 
                            //   onChanged: (val){
                            //     setState(() {
                            //       id = val;
                            //       _showTraining = false;
                            //       _showEmployees = true;
                            //       _showClient = false;
                            //       _showProject = false;
                            //     });
                            //     print(val);
                            //   }
                            // ),
                            SizedBox(height: 10),
                            widget.is_consultant == "0" ? 
                              TextField(
                                onTap: (){
                                  setState(() {
                                    id = _mode![0].suport_service["id"];
                                    _showTraining = false;
                                    _showEmployees = true;
                                    _showClient = false;
                                    _showProject = false;

                                    _showChildBT = false;
                                    _showChildCT = false;
                                    _showChildDev = false;
                                    _showChildOA = false;
                                  });
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                  focusedBorder:  UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: (){},
                                    icon: id == 8 ? Icon(Icons.check, color: Config().primary,) : SizedBox(),
                                  ),
                                ),
                                controller: TextEditingController(text: "${_mode![0].suport_service["name"]}"),
                              ) : SizedBox(),
                            

                            //------------ Training -------------
                            // RadioListTile(
                            //   contentPadding: EdgeInsets.all(0),
                            //   title: Text("${_mode![0].training["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                            //   value: _mode![0].training["id"], 
                            //   groupValue: id, 
                            //   onChanged: (val){
                            //     setState(() {
                            //       id = val;
                            //       _showTraining = true;
                            //       _showEmployees = false;
                            //       _showClient = false;
                            //       _showProject = false;
                            //     });
                            //     print(val);
                            //   }
                            // ),
                            SizedBox(height: 10),
                            TextField(
                              onTap: (){
                                setState(() {
                                  id = _mode![0].training["id"];
                                  _showTraining = true;
                                  _showEmployees = false;
                                  _showClient = false;
                                  _showProject = false;

                                  _showChildBT = false;
                                  _showChildCT = false;
                                  _showChildDev = false;
                                  _showChildOA = false;
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                focusedBorder:  UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: (){},
                                  icon: id == 9 ? Icon(Icons.check, color: Config().primary,) : SizedBox(),
                                ),
                              ),
                              controller: TextEditingController(text: "${_mode![0].training["name"]}"),
                            ),
                            
                            // ---------- Development -----------
                            SizedBox(height: 10),
                            TextField(
                              onTap: (){
                                setState(() {
                                  _showChildDev = !_showChildDev;
                                  _showChildBT = false;
                                  _showChildCT = false;
                                  _showChildOA = false;
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                focusedBorder:  UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: (){},
                                  icon: id == 14 || id == 27 ? Icon(Icons.check, color: Config().primary,) : SizedBox(),
                                ),
                              ),
                              controller: TextEditingController(text: "${_mode![0].development["name"]}"),
                            ),
                            _showChildDev == true ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text("${_mode![0].development["sub"]['1']['name']}", style: TextStyle( fontSize: 14)),
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
                                RadioListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text("${_mode![0].development["sub"]['2']['name']}", style: TextStyle( fontSize: 14)),
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
                              ],
                            ) : SizedBox(),

                            // Client
                            //  _showClient == true ? Padding(
                            //   padding: const EdgeInsets.only(left: 10),
                            //   child: Text("Client", style: TextStyle(fontWeight: FontWeight.w500)),
                            // ) : SizedBox(),
                            SizedBox(height: 20),
                            widget.is_consultant == "1" ?
                            _showClient == true ? Column(
                              children: [
                                Consumer<TimesheetState>(
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
                                        hintText: "Client",
                                        suffixIcon: IconButton(
                                          onPressed: (){
                                            print('woy');
                                            Provider.of<TimesheetState>(context, listen: false).changeIndexA(null);
                                            _foundAssignment = _assignment!;
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
                                                      initialChildSize: .8,
                                                      minChildSize: 0.25,
                                                      maxChildSize: 0.97,
                                                      expand: false,
                                                      builder: (context, scrollController) {
                                                        return Column(
                                                          children: [
                                                            Container(
                                                              width: width,
                                                              height: 180,
                                                              child: ListView(
                                                                controller: scrollController,
                                                                children: [
                                                                Align(
                                                                  alignment: Alignment.topCenter,
                                                                  child: Container(
                                                                    // margin: EdgeInsets.symmetric(vertical: 8),
                                                                    height: 5.0,
                                                                    width: 70.0,
                                                                    decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10.0)),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 16),
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 20 ,bottom: 20),
                                                                  child: Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: (){
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Icon(Icons.close_outlined, color: Colors.black, size: 34,)
                                                                      ),
                                                                      SizedBox(width: 20),
                                                                      Text('Select Assignment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Divider(),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                                                  child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  SizedBox(height: 10.0),
                                                                  TextFormField(
                                                                    onChanged: (value) => _runFilterAssignment(value),
                                                                    decoration: InputDecoration(
                                                                      isDense: true, 
                                                                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10,1),
                                                                      hintText: "Search Client Name",
                                                                      prefixIcon: Icon(Icons.search),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius:BorderRadius.all(Radius.circular(10.0)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                                  ),
                                                                ),
                                                                SizedBox(height: 10),

                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:  _foundUsers.isNotEmpty
                                                                ? ListView.builder(
                                                                  // controller: scrollController,
                                                                  itemCount: _foundAssignment.length,
                                                                  itemBuilder: ((context, i){
                                                                    return Padding(
                                                                      padding: const EdgeInsets.all(10.0),
                                                                      child: CardAssignment(width: width, companies_name: _foundAssignment[i].companies_name, name_service: _foundAssignment[i].service_name, year: _foundAssignment[i].service_period, ope: _foundAssignment[i].ope, assign_numbber: _foundAssignment[i].assignment_number, scope: _foundAssignment[i].service_scope, proposal_id: _foundAssignment[i].proposal_id, service_id: _foundAssignment[i].services_id, serviceused_id: _foundAssignment[i].serviceused_id, i: i,),
                                                                    );
                                                                  }),
                                                              ) : const Text(
                                                              'No results found',
                                                              style: TextStyle(fontSize: 24),
                                                            ),),
                                                            
                                                          ],
                                                        );
                                                      }
                                                    );
                                                  }
                                                );
                                              },
                                            );
                                          },
                                          icon: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:BorderRadius.circular(20),
                                              border: Border.all(
                                                  color:Colors.orange,
                                                  width: 2)),
                                          child: Padding(
                                            padding:const EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.more_horiz,
                                              color: Colors.orange,
                                              size: 16,
                                            ),
                                          )),
                                        )
                                      ),
                                      
                                    );
                                  }
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
                            ) : SizedBox() : SizedBox(),

                            _showEmployees == true ?
                            Consumer<TimesheetState>(
                              builder: (context, data, _) {
                                return TextField(
                                  readOnly: true,
                                  controller: employeeNameC..text = data.employeeName,
                                  decoration: InputDecoration(
                                    label: Text("Employees"),
                                    suffixIcon: IconButton(
                                      onPressed: (){
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
                                                  initialChildSize: .8,
                                                  minChildSize: 0.25,
                                                  maxChildSize: 0.97,
                                                  expand: false,
                                                  builder: (context, scrollController) {
                                                    return Column(
                                                      children: <Widget>[
                                                        // Put all heading in column.
                                                        Container(
                                                          width: width,
                                                          height: 150,
                                                          child: ListView(
                                                            controller: scrollController,
                                                            children: <Widget>[
                                                              Align(
                                                                alignment: Alignment.topCenter,
                                                                child: Container(
                                                                  height: 5.0,
                                                                  width: 70.0,
                                                                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10.0)),
                                                                ),
                                                              ),
                                                              SizedBox(height: 16),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                                                child: Row(
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: (){
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Icon(Icons.close_outlined, color: Colors.black, size: 34,)
                                                                        ),
                                                                        SizedBox(width: 20),
                                                                        Text('Select Employees', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                                      ],
                                                                    ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    SizedBox(height: 20.0),
                                                                    TextFormField(
                                                                      onChanged: (value) => _runFilter(value),
                                                                      decoration: const InputDecoration(
                                                                        isDense: true, 
                                                                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                                        hintText: 'Search',
                                                                        prefixIcon: Icon(Icons.search),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius:BorderRadius.all(Radius.circular(10.0)),
                                                                          ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height: 16),
                                                            ],
                                                          ),
                                                        ),
                                                        // Wrap your DaysList in Expanded and provide scrollController to it
                                                        Expanded(child: _foundUsers.isNotEmpty
                                                          ? ListView.builder(
                                                              itemCount: _foundUsers.length,
                                                              itemBuilder: (context, index) => Card(
                                                                // key: ValueKey(_foundUsers[index].id),
                                                                // elevation: 1,
                                                                // margin: const EdgeInsets.symmetric(vertical: 10),
                                                                child: Consumer<TimesheetState>(
                                                                  builder: (context, data, _) {
                                                                    return ListTile(
                                                                      leading: CircleAvatar(
                                                                        backgroundImage: NetworkImage(_foundUsers[index].url_photo!),
                                                                        backgroundColor: Colors.grey,
                                                                      ),
                                                                      title: Text(_foundUsers[index].fullname),
                                                                      trailing: data.indexSelectedEmployee == _foundUsers[index].id ? Icon(Icons.check, color: Config().primary,) : SizedBox(),
                                                                      onTap: (){
                                                                        employeeIdMode = _foundUsers[index].id;
                                                                        Provider.of<TimesheetState>(context, listen: false).changeemployeeName(_foundUsers[index].fullname);
                                                                        Provider.of<TimesheetState>(context, listen: false).changeIndexSelectedEmployee(_foundUsers[index].id);
                                                                        Navigator.pop(context);
                                                                      },
                                                                    );
                                                                  }
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
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:BorderRadius.circular(20),
                                            border: Border.all(
                                                color:Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding:const EdgeInsets.all(3.0),
                                          child: Icon(
                                            Icons.more_horiz,
                                            color: Colors.orange,
                                            size: 16,
                                          ),
                                        )),
                                    )
                                  ),

                                );
                              }
                            ) : SizedBox(),
                            
                            _showTraining == true ?
                            Consumer<TimesheetState>(
                              builder: (context, data, _) {
                                return TextField(
                                  readOnly: true,
                                  controller: trainingNameC..text = data.trainingName,
                                  decoration: InputDecoration(
                                    label: Text("Training"),
                                    suffixIcon: IconButton(
                                      onPressed: (){
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
                                                  initialChildSize: .8,
                                                  minChildSize: 0.25,
                                                  maxChildSize: 0.97,
                                                  expand: false,
                                                  builder: (context, scrollController) {
                                                    return Padding(
                                                      padding: const EdgeInsets.only(top: 0),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: width,
                                                            height: 75,
                                                            child: ListView(
                                                              controller: scrollController,
                                                              children: [
                                                                Align(
                                                                  alignment: Alignment.topCenter,
                                                                  child: Container(
                                                                    margin: EdgeInsets.symmetric(vertical: 0),
                                                                    height: 5.0,
                                                                    width: 70.0,
                                                                    decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10.0)),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 16),
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 20,bottom: 20),
                                                                  child: Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: (){
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Icon(Icons.close_outlined, color: Colors.black, size: 34,)
                                                                      ),
                                                                      SizedBox(width: 20),
                                                                      Text('Select Training', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(),
                                                          Expanded(
                                                            child: ListView.builder(
                                                              // controller: scrollController,
                                                              // physics: NeverScrollableScrollPhysics(),
                                                              // shrinkWrap: true,
                                                              itemCount: _training?.length,
                                                              itemBuilder: ((context, i){
                                                                  return Ink(
                                                                  child: Container(
                                                                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                                                                    child: ListTile(
                                                                      title: Text("${_training![i].training_name}"),
                                                                      onTap: (){
                                                                        trainingIdMode = _training![i].id.toString();
                                                                        Provider.of<TimesheetState>(context, listen: false).changeTrainingName(_training![i].training_name);
                                                                        Navigator.pop(context);
                                                                      },
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                );
                                              }
                                            );
                                          },
                                        );
                                      },
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:BorderRadius.circular(20),
                                            border: Border.all(
                                                color:Colors.orange,
                                                width: 2)),
                                        child: Padding(
                                          padding:const EdgeInsets.all(3.0),
                                          child: Icon(
                                            Icons.more_horiz,
                                            color: Colors.orange,
                                            size: 16,
                                          ),
                                        )),
                                    )
                                  ),

                                );
                              }
                            ) : SizedBox(),

                            _showProject == true ?
                            Consumer<TimesheetState>(
                              builder: (context, data, _) {
                                return TextFormField(
                                  readOnly: true,
                                  controller: projectNameC..text = data.projectName,
                                  decoration: InputDecoration(
                                    label: Text("project"),
                                    suffixIcon: IconButton(
                                      onPressed: (){
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
                                                  initialChildSize: .8,
                                                  minChildSize: 0.25,
                                                  maxChildSize: 0.97,
                                                  expand: false,
                                                  builder: (context, scrollController) {
                                                    return Column(
                                                      children: [
                                                        // SizedBox(height: 10),
                                                        Container(
                                                          width: width,
                                                          height: 75,
                                                          child: ListView(
                                                            controller: scrollController,
                                                            children: [
                                                              Align(
                                                                alignment: Alignment.topCenter,
                                                                child: Container(
                                                                  // margin: EdgeInsets.symmetric(vertical: 8),
                                                                  height: 5.0,
                                                                  width: 70.0,
                                                                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10.0)),
                                                                ),
                                                              ),
                                                              SizedBox(height: 16),
                                                              Padding(
                                                                padding: EdgeInsets.only(left: 20,bottom: 20),
                                                                child: Row(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Icon(Icons.close_outlined, color: Colors.black, size: 34,)
                                                                    ),
                                                                    SizedBox(width: 20),
                                                                    Text('Select Project', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(),
                                                        Expanded(
                                                          child: ListView.builder(
                                                            // physics: NeverScrollableScrollPhysics(),
                                                            // shrinkWrap: true,
                                                            itemCount: _project?.length,
                                                            itemBuilder: ((context, i){
                                                              return Ink(
                                                                child: Container(
                                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                                                                  child: Consumer<TimesheetState>(
                                                                    builder: (context, data, _) {
                                                                      return ListTile(
                                                                        trailing: data.indexSelectedProject == i ? Icon(Icons.check, size: 34, color: Config().primary,) : SizedBox(),
                                                                        title: Text("${_project![i].project_name}"),
                                                                        onTap: (){
                                                                          projectIdMode = _project![i].id;
                                                                          Provider.of<TimesheetState>(context, listen: false).changeProjectName(_project![i].project_name!);
                                                                          Provider.of<TimesheetState>(context, listen: false).changeIndexSelectedProject(i);
                                                                          Navigator.pop(context);
                                                                        },
                                                                        shape: Border.all(color: Config().line, width: 1),

                                                                      );
                                                                    }
                                                                  ),
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
                                      icon: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 0),
                                        child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:BorderRadius.circular(20),
                                          border: Border.all(
                                              color:Colors.orange,
                                              width: 2)),
                                      child: Padding(
                                        padding:const EdgeInsets.all(3.0),
                                        child: Icon(
                                          Icons.more_horiz,
                                          color: Colors.orange,
                                          size: 16,
                                        ),
                                      ))
                                      ),
                                    )
                                  ),

                                );
                              }
                            ) : SizedBox(),


                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Config().primary,
                                minimumSize: const Size.fromHeight(50), // NEW
                              ),
                              onPressed: (){
                                // return null;
                                

                                // -- try
                                //  cek first isi 
                                if (_timeX.isEmpty) {
                                  setState(() {
                                    _load = true;
                                  });
                                  postTimesheet().then((value) {
                                    setState(() {
                                      _load= false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      duration: Duration(seconds: 4),
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
                                    print(check_end_time);
                                    print([_timeOfDayEnd, V_end_time]);
                                    if (check_end_time == false ) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text("Time Not Valid!"),
                                      ));
                                    }else{
                                      setState(() {
                                        _load = true;
                                      });
                                      print('valid1');
                                      postTimesheet().then((value) {
                                        setState(() {
                                          _load= false;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          duration: Duration(seconds: 4),
                                          content: Text("${value['message']}"),
                                        ));
                                        value['status'] == true ? Navigator.pop(context, dateinput.text) : null;
                                      });
                                    }
                                  }else{
                                    print('valid2');
                                    setState(() {
                                      _load = true;
                                    });
                                    postTimesheet().then((value) {
                                      setState(() {
                                        _load= false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        duration: Duration(seconds: 4),
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

    // validasi input time harus maksimal 3 jam
    DateTime startDateTime = DateTime.parse("1970-01-01 " + timeStart.text + ":00");
    DateTime endDateTime = DateTime.parse("1970-01-01 " + timeEnd.text + ":00");
    
    int secondsBetween = endDateTime.difference(startDateTime).inSeconds;
    if (secondsBetween > 10800 ) {
      return {"status": false, "message": "Time duration maximum 3 hours"};
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
      if(employeeIdMode == null){
        return {"status": false, "message": "Your form is not complete!"};
      }
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
      if(projectIdMode == null){
        return {"status": false, "message": "Your form is not complete!"};
      }
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
    }else if(id == 23 || id == 22 || id == 19 || id == 15 || id == 17 ||id == 16 || id == 21 || id == 20 || id == 18 || id == 24 || id == 25){
      // jika bisnis travel untuk non konsultan boleh kosong
      if(id == 23 || id == 22 || id == 19 || id == 15 || id == 17 ||id == 16 || id == 21 || id == 20 || id == 18){
        if(proposalIdMode == null || serviceIdMode == null || serviceUserIdMode == null){
          return {"status": false, "message": "Your form is not complete!"};
        }
      }
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
     if(trainingIdMode == null){
      return {"status": false, "message": "Your form is not complete!"};
     }
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

    if(_timeX.isNotEmpty){
      // Default time
      var str = "${_timeX.last}";

      // get next 1 hour
      String timeString = str;
      DateTime time = DateTime.parse("2023-02-16 $timeString:00"); // parse time string to DateTime object
      DateTime nextHour = time.add(Duration(hours: 1)); // add one hour to the time
      String nextHourString = "${nextHour.hour.toString().padLeft(2, '0')}:${nextHour.minute.toString().padLeft(2, '0')}"; // convert DateTime to string in "hh:mm" format
      var parts = str.split(':');
      var parts2 = nextHourString.split(':');

      setState(() {
        timeStart.text = "${str}";
        timeEnd.text = "${nextHourString}";
        _Tstart = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        _Tend = TimeOfDay(hour: int.parse(parts2[0]), minute: int.parse(parts2[1]));
        _timeOfDayStart = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      _timeOfDayEnd = TimeOfDay(hour: int.parse(parts2[0]), minute: int.parse(parts2[1]));
      });
    }
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
    _foundAssignment = _assignment!;
  }

  getProject()async{
    _project = await ProjectApi.getDataProject(context);
  }

  getTraining()async{
    _training = await TrainingApi.getDataProject(context, dateinput.text);
  }
}



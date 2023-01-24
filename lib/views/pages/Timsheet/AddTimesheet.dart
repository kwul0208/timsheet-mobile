import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Helper/Helper.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimeExistApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/ModeApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/ModeModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/employees/EmployeesApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/employees/EmployeesModel.dart';

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


  @override
  void initState(){
    super.initState();

    dateinput.text = widget.date;
    getTimeExist();
    _futureMode = getMode();
    _futureEmployees = getEmployees();

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

  int id = 0;

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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
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
                  child: Text("Save"),
                ),
                // child: Center(
                //     child: Text(
                //   "save",
                //   style: TextStyle(color: Colors.green, fontSize: 16),
                // )),
              ),
            ],
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
                            //----------- Prospecting -----------
                            RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("${_mode![0].prospecting["name"]}"),
                              value: _mode![0].prospecting["id"], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),
                            // ---------- Office Ad -----------
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("${_mode![0].office_admisitration["name"]}"),
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].office_admisitration["sub"]['1']['name']}", style: TextStyle(color: Config().subText, fontSize: 13),),
                              value: _mode![0].office_admisitration["sub"]['1']['id'], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showEmployees = false;
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
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),

                            //------------- BS Travel ----------
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("${_mode![0].business_travel["name"]}"),
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].business_travel["sub"]['1']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].business_travel["sub"]['1']['id'], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showEmployees = false;
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
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),
                            
                            //------------ Ishoma -------------
                            RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("${_mode![0].ishoma["name"]}"),
                              value: _mode![0].ishoma["id"], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),

                            //------------ Suport service -------------
                            RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("${_mode![0].suport_service["name"]}"),
                              value: _mode![0].suport_service["id"], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showEmployees = true;
                                });
                                print(val);
                              }
                            ),
                            FutureBuilder(
                              future: _futureEmployees,
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: _showEmployees == true ? DropdownButton<EmployeesModel>(
                                      hint: Text("-- Choose --"),
                                      value: selectedUser,
                                      onChanged: (EmployeesModel? newValue) {
                                        setState(() {
                                          selectedUser = newValue;
                                        });
                                      },
                                      items: _employees?.map((EmployeesModel user) {
                                        return new DropdownMenuItem<EmployeesModel>(
                                          value: user,
                                          child: Text(
                                            user.fullname,
                                            style: new TextStyle(color: Colors.black),
                                          ),
                                        );
                                      }).toList(),
                                    ) : SizedBox(),
                                  );
                                }else{
                                  return SizedBox();
                                }
                              }
                            ),


                            //------------ Training -------------
                            RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("${_mode![0].training["name"]}"),
                              value: _mode![0].training["id"], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),
                            
                            // ---------- Development -----------
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("${_mode![0].development["name"]}"),
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].development["sub"]['1']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].development["sub"]['1']['id'], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].development["sub"]['2']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].development["sub"]['2']['id'], 
                              groupValue: id, 
                              onChanged: (val){
                                setState(() {
                                  id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
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
    request.body = json.encode({
      "timestart": "${timeStart.text}",
      "timefinish": "${timeEnd.text}",
      "date": "${dateinput.text}",
      "is_overtime": "0",
      "input_from": "pms",
      "description": "${description.text}",
      "employees_id": "575",
      "tmode_id": id
    });
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
    _timeX = await TimeExistapi.getTime(context, widget.date);
  }

  getMode()async{
    _mode = await ModeApi.getDataMode(context);
    print('mode');
    print(_mode);
  }

  
  getEmployees()async{
    _employees = await EmployeesApi.getEmployees(context);
    print("employees");
    print(_employees);
    // selectedUser=_employees![0];
  }
}

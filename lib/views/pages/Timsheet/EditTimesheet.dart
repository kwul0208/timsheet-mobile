import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Models/Timesheet/mode/ModeApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/ModeModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/employees/EmployeesApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/employees/EmployeesModel.dart';

class EditTimesheet extends StatefulWidget {
  const EditTimesheet({super.key, required this.id, required this.date, required this.timeStart, required this.timeEnd, required this.desc, required this.tmode_id});

  final int id;
  final String date;
  final String timeStart;
  final String timeEnd;
  final String desc;
  final int tmode_id;

  @override
  State<EditTimesheet> createState() => _EditTimesheetState();
}

class _EditTimesheetState extends State<EditTimesheet> {
  // view state
  bool _load = false;
  bool _showEmployees = false;

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
  String mode = '';


  // mode
  List<ModeModel>? _mode;
  Future<dynamic>? _futureMode;
  int _mode_id = 0;
  
  // list employees
  EmployeesModel? selectedUser;
  List<EmployeesModel> ? _employees;
  Future<dynamic>? _futureEmployees;



  @override
  void initState(){
    super.initState();

    // initial value
    dateinput.text = widget.date;
    timeStart.text = widget.timeStart;
    timeEnd.text = widget.timeEnd;
    description.text = widget.desc;
    
    // Default time
    var str = timeStart.text;
    var parts = str.split(':');
    _Tstart = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    var str2 = timeEnd.text;
    var parts2 = str2.split(':');
    _Tend = TimeOfDay(hour: int.parse(parts2[0]), minute: int.parse(parts2[1]));


    // mode
    _futureMode = getMode();
    _mode_id = widget.tmode_id;
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
            title: Text("Edit Timesheet",
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
                            initialTime: _Tstart,
                            context: context,
                          );

                          if (pickedTime != null) {
                            String formattedTime = pickedTime.format(context);

                            setState(() {
                              timeStart.text = formattedTime; //set the value of text field.
                              _Tstart = pickedTime;
                            });
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
                            initialTime: _Tend,
                            context: context,
                          );

                          if (pickedTime != null) {
                            String formattedTime = pickedTime.format(context);
                            print(formattedTime); //output 14:59:00
                            //DateFormat() is from intl package, you can format the time on any pattern you need.

                            setState(() {
                              timeEnd.text = formattedTime;
                              _Tend = pickedTime; //set the value of text field.
                            });
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
                                  groupValue: _mode_id, 
                                  onChanged: (val){
                                    setState(() {
                                      _mode_id = val;
                                      _showEmployees = false;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['2']['sub']['2']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['2']['sub']['2']['id'], 
                                  groupValue: _mode_id, 
                                  onChanged: (val){
                                    setState(() {
                                      _mode_id = val;
                                      _showEmployees = false;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['2']['sub']['3']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['2']['sub']['3']['id'], 
                                  groupValue: _mode_id, 
                                  onChanged: (val){
                                    setState(() {
                                      _mode_id = val;
                                      _showEmployees = false;
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
                                  groupValue: _mode_id, 
                                  onChanged: (val){
                                    setState(() {
                                      _mode_id = val;
                                      _showEmployees = false;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['3']['sub']['2']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['3']['sub']['2']['id'], 
                                  groupValue: _mode_id, 
                                  onChanged: (val){
                                    setState(() {
                                      _mode_id = val;
                                      _showEmployees = false;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['3']['sub']['3']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['3']['sub']['3']['id'], 
                                  groupValue: _mode_id, 
                                  onChanged: (val){
                                    setState(() {
                                      _mode_id = val;
                                      _showEmployees = false;
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
                                  groupValue: _mode_id, 
                                  onChanged: (val){
                                    setState(() {
                                      _mode_id = val;
                                      _showEmployees = false;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['1']['sub']['2']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['1']['sub']['2']['id'], 
                                  groupValue: _mode_id, 
                                  onChanged: (val){
                                    setState(() {
                                      _mode_id = val;
                                      _showEmployees = false;
                                    });
                                    print(val);
                                  }
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text("${_mode![0].chargeable_time["sub"]['1']['sub']['3']['name']}", style: TextStyle(fontSize: 13, color: Config().subText),),
                                  value: _mode![0].chargeable_time["sub"]['1']['sub']['3']['id'], 
                                  groupValue: _mode_id, 
                                  onChanged: (val){
                                    setState(() {
                                      _mode_id = val;
                                      _showEmployees = false;
                                    });
                                    print(val);
                                  }
                                ),

                            //----------- Prospecting -----------
                            SizedBox(height: 10),
                            RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("${_mode![0].prospecting["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              value: _mode![0].prospecting["id"], 
                              groupValue: _mode_id, 
                              onChanged: (val){
                                setState(() {
                                  _mode_id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),
                            // ---------- Office Ad -----------
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("${_mode![0].office_admisitration["name"]}", style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].office_admisitration["sub"]['1']['name']}", style: TextStyle(color: Config().subText, fontSize: 13),),
                              value: _mode![0].office_admisitration["sub"]['1']['id'], 
                              groupValue: _mode_id, 
                              onChanged: (val){
                                setState(() {
                                  _mode_id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].office_admisitration["sub"]['2']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].office_admisitration["sub"]['2']['id'], 
                              groupValue: _mode_id, 
                              onChanged: (val){
                                setState(() {
                                  _mode_id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),

                            //------------- BS Travel ----------
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("${_mode![0].business_travel["name"]}", style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].business_travel["sub"]['1']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].business_travel["sub"]['1']['id'], 
                              groupValue: _mode_id, 
                              onChanged: (val){
                                setState(() {
                                  _mode_id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].business_travel["sub"]['2']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].business_travel["sub"]['2']['id'], 
                              groupValue: _mode_id, 
                              onChanged: (val){
                                setState(() {
                                  _mode_id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),
                            
                            //------------ Ishoma -------------
                            RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("${_mode![0].ishoma["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              value: _mode![0].ishoma["id"], 
                              groupValue: _mode_id, 
                              onChanged: (val){
                                setState(() {
                                  _mode_id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),

                            //------------ Suport service -------------
                            RadioListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("${_mode![0].suport_service["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              value: _mode![0].suport_service["id"], 
                              groupValue: _mode_id, 
                              onChanged: (val){
                                setState(() {
                                  _mode_id = val;
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
                              title: Text("${_mode![0].training["name"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              value: _mode![0].training["id"], 
                              groupValue: _mode_id, 
                              onChanged: (val){
                                setState(() {
                                  _mode_id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),
                            
                            // ---------- Development -----------
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("${_mode![0].development["name"]}", style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].development["sub"]['1']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].development["sub"]['1']['id'], 
                              groupValue: _mode_id, 
                              onChanged: (val){
                                setState(() {
                                  _mode_id = val;
                                  _showEmployees = false;
                                });
                                print(val);
                              }
                            ),
                            RadioListTile(
                              title: Text("${_mode![0].development["sub"]['2']['name']}", style: TextStyle(color: Config().subText, fontSize: 13)),
                              value: _mode![0].development["sub"]['2']['id'], 
                              groupValue: _mode_id, 
                              onChanged: (val){
                                setState(() {
                                  _mode_id = val;
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
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Config().primary,
                      minimumSize: const Size.fromHeight(50), // NEW
                    ),
                    onPressed: () {
                      setState(() {
                        _load = true;
                      });
                      updateTimesheet().then((value){
                        setState(() {
                          _load = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("${value['message']}"),
                        ));
                        value['status'] == true ? {
                          Navigator.pop(context, dateinput.text),
                          Navigator.pop(context, dateinput.text)
                        } : null;
                      });
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
  
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

  Future updateTimesheet()async{
    if(timeStart.text.isEmpty|| timeEnd.text.isEmpty || dateinput.text.isEmpty || description.text.isEmpty ||  _mode_id == 0){
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
    //   "tmode_id": widget.tmode_id,
    //   "timesheet_id": widget.id
    // });
    // print(DateTime.now());
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
      "tmode_id": _mode_id,
      "timesheet_id": widget.id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    // print(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      var x = await response.stream.bytesToString();
      Map data = jsonDecode(x);
      print(data);

      if (data['status'] == "success") {
        return {"status": true, "message": "success"};
      }else{
          return {"status": false, "message": "$data"};
      }
    }
    else {
      return {"status": false, "message": "${response.reasonPhrase}"};
    }
  }

  getMode()async{
    _mode = await ModeApi.getDataMode(context);
  }

  getEmployees()async{
    _employees = await EmployeesApi.getEmployees(context);
    print("employees");
    print(_employees);
    // selectedUser=_employees![0];
  }
}

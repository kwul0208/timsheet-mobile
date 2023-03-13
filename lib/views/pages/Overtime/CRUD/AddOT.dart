import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/Routing/SlideRightRoute.dart';
import 'package:timsheet_mobile/views/pages/Overtime/CRUD/EmployeeList.dart';

class AddOT extends StatefulWidget {
  const AddOT({super.key});

  @override
  State<AddOT> createState() => _AddOTState();
}

class _AddOTState extends State<AddOT> {
   // state
  bool _load = false;
  List _get = [];

  // form
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeStart = TextEditingController();
  TextEditingController timeEnd = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController employeeNameC = TextEditingController();
  TextEditingController internNameC = TextEditingController();

  int employeeId = 0 ;
 
  // Group Value for Radio Button.
  String forU = "my_self";

  @override
  void initState(){
    super.initState();
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
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Image.asset("assets/x.png", scale: 1.8,)),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Add Overtime Plan",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
            elevation: 0,
            actions: [
              GestureDetector(
                onTap: ()async{
                  setState(() {
                    _load = true;
                  });
                  await postOvertime().then((value){
                    if (value['status'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 4),
                        content: Text("${value['message']}"),
                      ));
                      Navigator.pop(context, 'reload');
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 4),
                        content: Text("${value['message']}"),
                      ));
                    }
                  });
                  setState(() {
                    _load = false;
                  });
                },
                child: Image.asset("assets/check.png", scale: 1.8,))
            ],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Text("For", style: TextStyle(fontSize: 13, color: Color.fromRGBO(0, 0, 0, 0.64)),),
                  ),
                  Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 'my_self',
                          groupValue: forU,
                          onChanged: (val) {
                            setState(() {
                              forU = 'my_self';
                            });
                          },
                        ),
                        Text(
                          'My Self',
                          style: new TextStyle(fontSize: 13.0),
                        ),
            
                        Radio(
                          value: 'other',
                          groupValue: forU,
                          onChanged: (val) {
                            setState(() {
                              forU = 'other';
                            });
                          },
                        ),
                        Text(
                          'Other',
                          style: new TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                        
                        Radio(
                          value: 'intern',
                          groupValue: forU,
                          onChanged: (val) {
                            setState(() {
                              forU = 'intern';
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            'Internship Employee',
                            style: new TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ],
                    ),

                  // --- EMPLOYEE ---
                  forU == 'other' ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Consumer<TimesheetState>(
                      builder: (context, data, _) {
                        if(data.indexSelectedEmployee != null){
                          employeeId = data.indexSelectedEmployee!;
                        }
                        return TextField(
                          // enabled: true,
                          controller: employeeNameC..text = data.employeeName, //editing controller of this TextField
                          decoration: InputDecoration(
                            labelText: "Employee", //label text of field
                            suffixIcon: GestureDetector(
                              onTap: (){
                                
                                Navigator.push(context, SlideRightRoute(page: EmployeeList()));
                              },
                              child: Image.asset("assets/arrow_left_circle.png", scale: 1.6,)
                            )
                          ),
                          readOnly:true, //set it true, so that user will not able to edit text
                          onTap: null
                        );
                      }
                    ),
                  )
                  : SizedBox(),

                  forU == 'intern' ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Consumer<TimesheetState>(
                      builder: (context, data, _) {
                        if(data.indexSelectedEmployee != null){
                          employeeId = data.indexSelectedEmployee!;
                        }
                        return TextField(
                          // enabled: true,
                          controller: internNameC,
                          decoration: InputDecoration(
                            labelText: "Employee", //label text of field
                          ),
                          onTap: null
                        );
                      }
                    ),
                  )
                  : SizedBox(),

                  // --- DATE ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: dateinput, //editing controller of this TextField
                      decoration: InputDecoration(
                          labelText: "Date" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? date = await showDatePicker(context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime(2016),
                          lastDate: new DateTime(2024),
                        );
                          if(date != null) {
                            String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                            setState(() {
                              dateinput.text = formattedDate;
                            });
                          };
                      }
                    ),
                  ),

                  // --- TIME START ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: timeStart, //editing controller of this TextField
                      decoration: InputDecoration(
                          labelText: "Time Start" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
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
                              String formattedTime = pickedTime.format(context);

                              setState(() {
                                timeStart.text = formattedTime; //set the value of text field.
                                // _Tstart = pickedTime;
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                    ),
                  ),

                  // --- TIME END ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: timeEnd, //editing controller of this TextField
                      decoration: InputDecoration(
                          labelText: "Time Start" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
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
                              String formattedTime = pickedTime.format(context);

                              setState(() {
                                timeEnd.text = formattedTime; //set the value of text field.
                                // _Tstart = pickedTime;
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                    ),
                  ),

                  // --- DESCRIPTION ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: desc,
                      decoration: InputDecoration(
                        label: Text("Description"),
                        alignLabelWithHint: true
                        // border: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Config().line,)
                        // )
                      ),
                      maxLines: 8,
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       primary: Config().primary,
                  //       minimumSize: const Size.fromHeight(50), // NEW
                  //     ),
                  //     onPressed: (){
                  //       if(_formKey.currentState!.validate()){
                  //         print([dateinput.text, employeeId, timeStart.text, timeEnd, desc.text]);
                  //       }
                  //     },
                  //     child: const Text(
                  //       'Save',
                  //       style: TextStyle(fontSize: 24),
                  //     ),
                  //   ),
                  // ),
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

  Future postOvertime()async{
    // await Future.delayed(Duration(seconds: 2));
    // return {"status": true, "message": "xxxxxxxx"};

    String baseUrl = Config().url;
    try {
      final storage = new FlutterSecureStorage();
      var employees_id = await storage.read(key: 'employees_id');

      Map<String, String> formData = {};

      // -- validation form
      // my self
      if (forU == 'my_self') {
        if(dateinput.text == '' || timeStart.text == '' || timeEnd.text == '' || desc.text == ''){
          return {"status": false, "message": "Your form is not complete!"};
        }
        formData = {
          'date': '${dateinput.text}',
          'for_employees_id': '${employees_id}',
          'timestart': '${timeStart.text}',
          'timefinish': '${timeEnd.text}',
          'reason': '${desc.text}',
          'plan_for': 'my_self',
        };
      // other
      }
      if(forU == 'other'){
        if(dateinput.text == '' || timeStart.text == '' || timeEnd.text == '' || desc.text == '' || employeeId == 0){
          return {"status": false, "message": "Your form is not complete!"};
        }
        formData = {
          'date': '${dateinput.text}',
          'for_employees_id': '$employeeId',
          'timestart': '${timeStart.text}',
          'timefinish': '${timeEnd.text}',
          'reason': '${desc.text}',
          'plan_for': 'other',
          'by_employees_id': '${employees_id}'
        };
      // intern
      } 
      if(forU == 'intern'){
        return {"status": false, "message": "This feature in development"};
        if(dateinput.text == '' || timeStart.text == '' || timeEnd.text == '' || desc.text == '' || internNameC.text == ''){
          return {"status": false, "message": "Your form is not complete!"};
        }
        formData = {
          'date': '${dateinput.text}',
          'for_employees_name': '${internNameC.text}',
          'timestart': '${timeStart.text}',
          'timefinish': '${timeEnd.text}',
          'reason': '${desc.text}',
          'plan_for': 'intern',
          
          
        };
      }

      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      
      var request = http.Request('POST', Uri.parse('$baseUrl/mucnet_api/api/overtimeplan/update'));
      request.bodyFields = formData;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var x = await response.stream.bytesToString();
        Map data = jsonDecode(x);

        if (data['status'] == "success") {
          return {"status": true, "message": "success"};
        }else{
          return {"status": false, "message": "failed"};
        }
      }
      else {
        print(response.reasonPhrase);
        return {"status": false, "message": "${response.reasonPhrase}"};
      }
    } catch (e) {
      return {"status": false, "message": "${e}"};
    }

  }
}
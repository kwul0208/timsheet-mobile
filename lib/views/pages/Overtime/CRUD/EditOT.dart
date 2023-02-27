import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/Routing/SlideRightRoute.dart';
import 'package:timsheet_mobile/views/pages/Overtime/CRUD/EmployeeList.dart';

class EditOT extends StatefulWidget {
  const EditOT({super.key});

  @override
  State<EditOT> createState() => _EditOTState();
}

class _EditOTState extends State<EditOT> {
  List _get = [];

  // form
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeStart = TextEditingController();
  TextEditingController timeEnd = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController employeeNameC = TextEditingController();

  late int employeeId ;
 
  // Group Value for Radio Button.
  int id = 1;

  @override
  Widget build(BuildContext context) {
    var size, height, width;

    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
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
        title: Text("Edit Overtime Plan",
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
        elevation: 0,
        actions: [
          Image.asset("assets/check.png", scale: 1.8,)
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
                      value: 1,
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          id = 1;
                        });
                      },
                    ),
                    Text(
                      'My Self',
                      style: new TextStyle(fontSize: 13.0),
                    ),
        
                    Radio(
                      value: 2,
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          id = 2;
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
                      value: 3,
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          id = 3;
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
              id == 2 ?
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
                      if(date != null) print(date);
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

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Config().primary,
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      print([dateinput.text, employeeId, timeStart.text, timeEnd, desc.text]);
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
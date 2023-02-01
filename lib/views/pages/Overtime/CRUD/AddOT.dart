import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddOT extends StatefulWidget {
  const AddOT({super.key});

  @override
  State<AddOT> createState() => _AddOTState();
}

class _AddOTState extends State<AddOT> {
  List _get = [];

  // form
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeStart = TextEditingController();
  TextEditingController timeEnd = TextEditingController();
  TextEditingController desc = TextEditingController();
  late int employeeId ;



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
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Add Overtime",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
        elevation: .5,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- DATE ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("Date: ", style: TextStyle(color: Config().subText)),
                    TextFormField(
                      controller:
                          dateinput, //editing controller of this TextField
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          hintText: 'Enter Date', //label text of field
                          border: InputBorder.none),
                      readOnly: true, //set it true, so that user will not able to edit text
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
                            dateinput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "required";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              //--- employee ---
              Container(
                height: 10,
                width: width,
                color: Config().line,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: DropdownSearch<dynamic>(
                  selectedItem: {"fullname": "asdasd", "id": "ddd"},
                  showSelectedItems: false,
                  showClearButton: true,
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Select Employee",
                    hintText: "Select Employee",
                    icon: Icon(Icons.person_add_sharp), //icon of text field
                      border: InputBorder.none,
                  ),
                  mode: Mode.DIALOG,
                  showSearchBox: true,
                  onFind: (text) async {
                    var response = await http.get(Uri.parse(
                        "http://103.115.28.155:1444/back_digital_signature/get-employees"));
        
                    if (response.statusCode == 200) {
                      final data = jsonDecode(response.body);
        
                      setState(() {
                        _get = data['data'];
                      });
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Error!"),
                      ));
                    }
        
                    return _get as List<dynamic>;
                  },
        
                  //what do you want anfter item clicked
                  onChanged: (value) {
                    if (value != null) {
                      print(value['fullname']);
                      print(value['id']);
                      print(value['signature']);
                    }
                  },
        
                  //this data appear in dropdown after clicked
                  itemAsString: (item) => item['fullname'],

                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "required!";
                    }
                    return null;
                  },
                ),
              ),
        
              // --- Timer ---
              Container(
                height: 10,
                width: width,
                color: Config().line,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                      controller: timeStart, //editing controller of this TextField
                      decoration: InputDecoration(
                          icon: Icon(Icons.timer), //icon of text field
                          labelText: "Start Time" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                        // _timeOfDayStart = pickedTime;

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

                          setState(() {
                            // timeStart.text = pickedTime.format(context); //set the value of text field.
                            timeStart.text = formattedTime; //set the value of text field.
                          });
                            
                          }
                        },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "required!";
                        }
                        return null;
                      },
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: TextFormField(
                      controller: timeEnd, //editing controller of this TextField
                      decoration: InputDecoration(
                          icon: Icon(Icons.timer), //icon of text field
                          labelText: "End Time" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                          // _timeOfDayStart = pickedTime;

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

                          setState(() {
                            // timeStart.text = pickedTime.format(context); //set the value of text field.
                            timeEnd.text = formattedTime; //set the value of text field.
                          });

                        }
                      },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "required";
                        }
                        return null;
                      },
                    )),
                  ],
                ),
              ),
              // ---- Reason ----
              Container(
                height: 10,
                width: width,
                color: Config().line,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.description_outlined, color: Colors.grey,),
                    SizedBox(width: 10,),
                    Flexible(
                      child: TextFormField(
                        maxLines: 5,
                        controller: desc, //editing controller of this TextField
                        decoration: InputDecoration(
                          // icon: Icon(Icons.description_outlined), //icon of text field
                          hintText: 'Description', //label text of field
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey[400]!,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "required";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height/4),
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
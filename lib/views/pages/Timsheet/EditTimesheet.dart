import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class EditTimesheet extends StatefulWidget {
  const EditTimesheet({super.key, required this.id, required this.date, required this.timeStart, required this.timeEnd, required this.desc});

  final int id;
  final String date;
  final String timeStart;
  final String timeEnd;
  final String desc;

  @override
  State<EditTimesheet> createState() => _EditTimesheetState();
}

class _EditTimesheetState extends State<EditTimesheet> {
  // view
  bool _load = false;

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
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 20.0,
                    children: options
                    .map((option) =>  Container(
                    // margin: EdgeInsets.all(5),
                      decoration: customBoxDecoration(option['isActive']),
                      child: InkWell(
                        onTap: () {
                          changeState(option);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Text('${option['title']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: option['isActive']
                            ? Colors.white
                            : Colors.black87)
                          )
                        )
                      )
                    )
                    ).toList()
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
    print({
      "timestart": "${timeStart.text}",
      "timefinish": "${timeEnd.text}",
      "date": "${dateinput.text}",
      "is_overtime": "0",
      "input_from": "pms",
      "description": "${description.text}",
      "employees_id": "575",
      "tmode_id": "13",
      "timesheet_id": widget.id
    });
    print(DateTime.now());
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
      "tmode_id": "13",
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
}

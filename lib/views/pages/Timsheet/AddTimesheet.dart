import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Helper/Helper.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimeExistApi.dart';

class addTimsheet extends StatefulWidget {
  const addTimsheet({super.key, required this.date});

  final String date;

  @override
  State<addTimsheet> createState() => _addTimsheetState();
}

class _addTimsheetState extends State<addTimsheet> {
  // view
  bool _load = false;

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


  @override
  void initState(){
    super.initState();

    dateinput.text = widget.date;
    getTimeExist();
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: (){
                    // return null;
                    // setState(() {
                    //   _load = true;
                    // });

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
                          print('valid');
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
                        print('valid');
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
                            print('timingx');
                            _timeOfDayStart = pickedTime;
                            // print(pickedTime.format(context)); //output 10:51 PM

                            //output 1970-01-01 22:53:00.000
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());
                                print(parsedTime);
                                
                            DateTime v_time = DateFormat.jm()
                                .parse(pickedTime.format(context).toString()).add(Duration(minutes: 1));

                            //output 14:59:00
                            String formattedTime =
                                DateFormat('HH:mm').format(parsedTime);
                            String v_f_time =
                                DateFormat('HH:mm').format(v_time);
                            
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

                            // print(pickedTime.format(context)); //output 10:51 PM

                            //output 1970-01-01 22:53:00.000
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());
                            DateTime v_time = DateFormat.jm()
                                .parse(pickedTime.format(context).toString()).add(Duration(minutes: -1));

                            //output 14:59:00
                            String formattedTime =
                                DateFormat('HH:mm').format(parsedTime);
                            String v_f_time =
                                DateFormat('HH:mm').format(v_time);
                            
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
    print({
      "timestart": "${timeStart.text}",
      "timefinish": "${timeEnd.text}",
      "date": "${dateinput.text}",
      "is_overtime": "0",
      "input_from": "pms",
      "description": "${description.text}",
      "employees_id": "575",
      "tmode_id": "13"
    });
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
      "tmode_id": "13"
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

  getTimeExist() async{
    print('timex');
    _timeX = await TimeExistapi.getTime(context, widget.date);
    print(_timeX);
  }
}

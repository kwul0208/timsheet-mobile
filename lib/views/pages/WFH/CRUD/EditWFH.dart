import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:appcheck/appcheck.dart';

class EditWFH extends StatefulWidget {
  const EditWFH({super.key});

  @override
  State<EditWFH> createState() => _EditWFHState();
}

class _EditWFHState extends State<EditWFH> {
  // --- form ---
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  List<TextEditingController> linksController = [ TextEditingController() ];
  String duration = '';
  String condition = '';
  TextEditingController timeStart = TextEditingController();
  TextEditingController timeEnd = TextEditingController();
  TextEditingController reason = TextEditingController();
  TextEditingController desc = TextEditingController();



  int _stackIndex = 0;

  String _singleValue = "Text alignment right";
  String _verticalGroupValue = "Pending";

  final _status = ["Half Day", "Full Day"]; 
  final _condition = ["Normal", "Same Day", "Overtime"]; 

  List<AppInfo>? installedApps;
  List<AppInfo> iOSApps = [
    AppInfo(appName: "Calendar", packageName: "calshow://"),
    AppInfo(appName: "Facebook", packageName: "fb://"),
    AppInfo(appName: "Whatsapp", packageName: "whatsapp://"),
  ];

  @override
  void initState(){
    super.initState();
    getApps();
  }

  @override
  void dispose(){
    for (var lc in linksController) {
      lc.dispose();
    }
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future getApps() async {
    if (Platform.isAndroid) {
      const package = "com.microsoft.planner";
      try {
        await AppCheck.checkAvailability(package).then(
          (app) {
            print('gada');
            debugPrint(app.toString());
          } 
        );
        print('ada');
        return true;
      } catch (e) {
        print('gada');
        return false;
      }

    } else if (Platform.isIOS) {
      // iOS doesn't allow to get installed apps.
      installedApps = iOSApps;

      await AppCheck.checkAvailability("calshow://").then(
        (app) => debugPrint(app.toString()),
      );
    }

    setState(() {
      installedApps = installedApps;
    });
  }

  // -- launch planner ---
  final Uri _url = Uri.parse('https://tasks.office.com/muc.co.id/en-US/Home/Planner/#/mytasks');
  Future<void> _launchUrl() async {
      if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $_url');
      }
    }

  // --- launch playstore(download planner)
  final Uri _urlPlaystore = Uri.parse('https://play.google.com/store/apps/details?id=com.microsoft.planner');
  Future<void> _launchUrlPlaystore() async {
      if (!await launchUrl(_urlPlaystore, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $_url');
      }
  }

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
        title: Text("Edit WFH",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date: ", style: TextStyle(color: Config().subText)),
                    TextFormField(
                      controller:
                          dateinput, //editing controller of this TextField
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          hintText: 'Enter Date', //label text of field
                          border: InputBorder.none),
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
                            dateinput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "required!";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
                width: width,
                color: Config().line,
              ),
              // --- Duration ---
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Duration: ", style: TextStyle(color: Config().subText)),
                    SizedBox(
                      height: 50.0,
                      child: RadioGroup<String>.builder(
                        direction: Axis.horizontal,
                        groupValue: duration,
                        horizontalAlignment: MainAxisAlignment.spaceAround,
                        onChanged: (value) => setState(() {
                          duration = value ?? '';
                        }),
                        items: _status,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // ---- Timmer ---
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
                            return "required!";
                          }
                          return null;
                      },
                    )),
                  ],
                ),
              ),
              // ---- Planner Link
              Container(
                height: 10,
                width: width,
                color: Config().line,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Planner Link: ", style: TextStyle(color: Config().subText)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset("assets/Microsoft_Planner.png", width: 50,),
                          SizedBox(width: 10,),
                          TextButton(
                            onPressed: (){
                              getApps().then((value)async{
                                if (value == true) {
                                  _launchUrl();
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("planner Apps is not installed in your device. Download please!."),
                                  ));
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  _launchUrlPlaystore();
                                }
                              });
                            },
                            child: Text("Click here!"),
                          )
                          
                        ],
                      ),
                      SizedBox(height: 10,),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: linksController.length,
                        itemBuilder: ( BuildContext context, i) {
                          return Row(
                            children: [
                              Flexible(
                                child: TextFormField(
                                  controller: linksController[i], //editing controller of this TextField
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.add_link), //icon of text field
                                    hintText: 'Copy your link here', //label text of field
                                    // border: InputBorder.none
                                  ),
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "required!";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              i != 0 ?
                              GestureDetector(
                                onTap: (){
                                  linksController.removeAt(i);
                                  setState(() {});
                                },
                                child: Icon(Icons.highlight_remove_sharp, color: Config().redAccent,)
                              ) 
                              : SizedBox()
                            ],
                          );
                        }
                      ),
                      TextButton(
                        onPressed: (){
                          setState(() {
                            linksController.add(TextEditingController());
                          });
                        }, 
                        child: Text("+ Add Link")
                      )
                    ],
                  ),
              ),
              // ---- Condition ----
              Container(
                height: 10,
                width: width,
                color: Config().line,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Condition", style: TextStyle(color: Config().subText)),
                    SizedBox(
                      height: 50.0,
                      child: RadioGroup<String>.builder(
                        direction: Axis.horizontal,
                        groupValue: condition,
                        horizontalAlignment: MainAxisAlignment.spaceAround,
                        onChanged: (value) => setState(() {
                          condition = value ?? '';
                        }),
                        items: _condition,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                        ),
                      ),
                    ),
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
                child: TextFormField(
                  maxLines: 1,
                  controller: reason, //editing controller of this TextField
                  decoration: InputDecoration(
                    icon: Icon(Icons.description_outlined), //icon of text field
                    hintText: 'Reason', //label text of field
                    border: InputBorder.none
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "required";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 10,
                width: width,
                color: Config().line,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  maxLines: 1,
                  controller: desc, //editing controller of this TextField
                  decoration: InputDecoration(
                    icon: Icon(Icons.description_outlined), //icon of text field
                    hintText: 'Description', //label text of field
                    border: InputBorder.none
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "required";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 10,
                width: width,
                color: Config().line,
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
                      if (duration == '' || condition == '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Your form is not complete!"),
                        ));
                      }
                      for (var e in linksController) {
                        print(e.text);
                      }
                      print([dateinput.text, timeStart.text, timeEnd.text, reason.text, desc.text, reason.text, duration, condition ]);
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

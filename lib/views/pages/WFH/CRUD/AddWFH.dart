import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:appcheck/appcheck.dart';

class AddWFH extends StatefulWidget {
  const AddWFH({super.key});

  @override
  State<AddWFH> createState() => _AddWFHState();
}

class _AddWFHState extends State<AddWFH> {
  // state
  bool _load = false;


  // --- form ---
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  String dateinputFix = '';
  List<TextEditingController> linksController = [ TextEditingController() ];
  String duration = '';
  String condition = '';
  TextEditingController timeStart = TextEditingController();
  TextEditingController timeEnd = TextEditingController();
  TextEditingController reason = TextEditingController();
  TextEditingController desc = TextEditingController();

  int id = 0;
  String durationVal = '';
  int conditionId= 0;
  String conditionVal = '';



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

  // String duration = "";

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
      print("Androind");
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
      print("ios");
      // iOS doesn't allow to get installed apps.
      installedApps = iOSApps;

      // await AppCheck.checkAvailability("https://itunes.apple.com/lookup?id=id1219301037").then(
      //   (app) => debugPrint(app.toString()),
      // );


      try {
        await AppCheck.checkAvailability("https://itunes.apple.com/lookup?id=id1219301037").then(
          (app) {
            debugPrint(app.toString());
          } 
        );
        print('ada');
        return true;
      } catch (e) {
        print('gada');
        return false;
      }
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

  // --- launch playstore(download planner)
  final Uri _urlAppStore = Uri.parse('https://apps.apple.com/us/app/microsoft-planner/id1219301037');
  Future<void> _launchUrlAppStore() async {
      if (!await launchUrl(_urlAppStore, mode: LaunchMode.externalApplication)) {
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
            title: Text("Add RWD",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
            elevation: 0,
            actions: [
              GestureDetector(
                child: Image.asset("assets/check.png", scale: 1.8,),
                onTap: () async{
                  setState(() {
                    _load = true;
                  });
                  List<String> _link = [];
                  for (var e in linksController) {
                    _link.add(e.text);
                  }
                  // print([dateinputFix, durationVal, _link, conditionVal, desc.text, timeStart.text, timeEnd.text]);
                  // await Future.delayed(Duration(seconds: 2));
                  await postWFH(dateinputFix, durationVal, _link, conditionVal, desc.text, timeStart.text, timeEnd.text).then((value){
                    if (value['status'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 4),
                        content: Text("${value['message']}"),
                      ));
                      Navigator.pop(context, true);
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
                  // postWFH().the
                },
              )
            ],
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
                        TextField(
                          controller: dateinput, //editing controller of this TextField
                          decoration: InputDecoration(
                              labelText: "Date" //label text of field
                              ),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? date = await showDatePicker(context: context,
                              initialDate: new DateTime.now(),
                              firstDate: new DateTime(2022),
                              lastDate: new DateTime(2024),
                            );
                              if(date != null){
                                DateTime dt = DateTime.parse("${date}");
                                String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                                String formattedDate2 = DateFormat("yyyy-MM-dd").format(dt);
                                setState(() {
                                  dateinput.text = formattedDate;
                                  dateinputFix = formattedDate2;
                                });
                              } ;
                          }
                        ),
                      ]
                    ),
                  ),
                  
                  // --- Duration ---
                  SizedBox(height: 16,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text("Duration", style: TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, .64)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              id = 1;
                              durationVal = "full_day";
                            });
                          },
                        ),
                        Text(
                          'Fullday',
                          style: new TextStyle(fontSize: 15.0),
                        ),
            
                        Radio(
                          value: 2,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              id = 2;
                              durationVal = "half_day";
                            });
                          },
                        ),
                        Text(
                          'Half Day',
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- TIME START ---
                  id == 2 ? Padding(
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
                  ) : SizedBox(),

                  // --- TIME END ---
                  id == 2 ? Padding(
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
                  ) : SizedBox(),

                  
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Container(
                            height: 30,
                            width: 130,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(172, 172, 172, 0.24),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Row(
                                children: [
                                  Image.asset("assets/Microsoft_Planner.png", width: 12,),
                                  SizedBox(width: 2,),
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
                                              if(Platform.isAndroid){
                                                _launchUrlPlaystore();
                                              }else{
                                                _launchUrlAppStore();
                                              }
                                          
                                        }
                                      });
                                    },
                                    child: Text("Open Ms. Planner", style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.58), fontSize: 10, fontWeight: FontWeight.w400),),
                                  )
                                  
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(height: 10,),
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
                                        suffixIcon: i != 0 ? GestureDetector(
                                          onTap: (){
                                            linksController.removeAt(i);
                                      setState(() {});
                                          },
                                          child: Image.asset("assets/delete.png", scale: 2.3,)) : null,
                                        labelText: 'Links', //label text of field
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
                                  // i != 0 ?
                                  // GestureDetector(
                                  //   onTap: (){
                                  //     linksController.removeAt(i);
                                  //     setState(() {});
                                  //   },
                                  //   child: Icon(Icons.highlight_remove_sharp, color: Config().redAccent,)
                                  // ) 
                                  // : SizedBox()
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
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: Config().orangePallet,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.add, color: Colors.white, size: 20,),
                                    Text("Add More Link", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10),),
                                  ],
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                  ),
                  // ---- Condition ----
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Condition", style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.64), fontSize: 15)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Radio(
                              value: 1,
                              groupValue: conditionId,
                              onChanged: (val) {
                                setState(() {
                                  conditionId = 1;
                                  conditionVal ="normal";
                                });
                              },
                            ),
                            Text(
                              'Normal',
                              style: new TextStyle(fontSize: 15.0),
                            ),
                  
                            Radio(
                              value: 2,
                              groupValue: conditionId,
                              onChanged: (val) {
                                setState(() {
                                  conditionId = 2;
                                  conditionVal = "same_day";
                                });
                              },
                            ),
                            Text(
                              'Same Day',
                              style: new TextStyle(
                                fontSize: 15.0,
                              ),
                            ),

                            Radio(
                              value: 3,
                              groupValue: conditionId,
                              onChanged: (val) {
                                setState(() {
                                  conditionId = 3;
                                  conditionVal = "overtime";
                                });
                              },
                            ),
                            Text(
                              'Overtime',
                              style: new TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // ---- Desc ----
                 Padding(
                   padding: EdgeInsets.symmetric(horizontal: 20),
                   child: TextFormField(
                    controller: desc,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Description', //label text of field
                        // border: InputBorder.none
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "required!";
                        }
                        return null;
                      },
                      maxLines: 3,
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

  // -- API --
  Future postWFH(dateinputFix, durationVal, _link, conditionVal, desc, timeStart, timeEnd)async{
    print([dateinputFix, durationVal, _link, conditionVal, desc, timeStart, timeEnd]);
    for (var e in _link) {
      if (e == '') {
        return {"status": false, "message": "Your form is not complete!"};
      }
    }
      // return {"status": false, "message": "Your form is not complete!"};

    if(dateinputFix == '' || durationVal == '' || conditionVal == '' || desc == ''){
      return {"status": false, "message": "Your form is not complete!"};
    }

    if (durationVal == "half_day") {
      if (timeStart == '' || timeEnd == '') {
        return {"status": false, "message": "Your form is not complete!"};
      }
    }
    print({
        "date": "$dateinputFix",
        "duration": "$durationVal",
        "start_hour": "$timeStart",
        "finish_hour": "$timeEnd",
        "condition": "$conditionVal",
        "reason": "",
        "description": "$desc",
        "link": _link,
        "input_from": "mobile_app"
      });

    try {
      final storage = new FlutterSecureStorage();
      var employees_id = await storage.read(key: 'employees_id');
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('http://103.115.28.155:1444/form_request/api/rwd/employees/$employees_id/create'));
      request.body = json.encode({
        "date": "$dateinputFix",
        "duration": "$durationVal",
        "start_hour": "$timeStart",
        "finish_hour": "$timeEnd",
        "condition": "$conditionVal",
        "reason": "",
        "description": "$desc",
        "link": _link,
        "input_from": "mobile_app"

      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
        var x = await response.stream.bytesToString();
        Map data = jsonDecode(x);

        if (data['code'] == 200) {
          return {"status": true, "message": "${data['message']}"};
        }else{
          return {"status": false, "message": "${data['message']}"};
        }
      }
      else {
        print(response.reasonPhrase);
        return {"status": false, "message": "${response.reasonPhrase}"};
      }
    } catch (e) {
      return {"status": false, "message": "${e}"};
    }

    // return {"status": false, "message": "Time duration maximum 3 hours"};
  }
}

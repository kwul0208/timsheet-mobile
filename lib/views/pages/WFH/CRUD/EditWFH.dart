import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:timsheet_mobile/Models/WFH/detail/DetailWFHApi.dart';
import 'package:timsheet_mobile/Models/WFH/detail/DetailWFHModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:appcheck/appcheck.dart';

class EditWFH extends StatefulWidget {
  const EditWFH({super.key, this.id, this.date, this.duration, this.condition, this.description});
  final int ? id;
  final String ? date;
  final String ? duration;
  final String ? condition;
  final String ? description;

  @override
  State<EditWFH> createState() => _EditWFHState();
}

class _EditWFHState extends State<EditWFH> {
  // --- form ---
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  List<TextEditingController> linksController = [];
  int lengthLinks = 0;
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

  List<DetailWFHModel>? _wfh;
  Future<dynamic>? _futureWfh;


  // String duration = "";

  @override
  void initState(){
    super.initState();
    getApps();
    _futureWfh = getDataWfh();

    // initial value
    dateinput.text = widget.date!;
    desc.text = widget.description!;
    durationVal = widget.duration!;
    if (widget.duration == 'full_day') {
      id = 1;
    }else{
      id = 2;
    }

    conditionVal = widget.condition!;
    if (widget.condition == "normal") {
      conditionId = 1;
    }else if(widget.condition == "same_day"){
      conditionId = 2;
    }else{
      conditionId = 3;
    }
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
    DateTime dt = DateTime.parse("${dateinput.text}");
    String formattedDate = DateFormat("dd MMMM yyyy").format(dt);

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
        title: Text("Edit RWD",
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
        elevation: 0,
        actions: [
          FutureBuilder(
            future: _futureWfh,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                  return Image.asset("assets/check.png", scale: 1.8,);
                }else{
                  return SizedBox();
                }
            }
          )
        ],
      ),
      body: FutureBuilder(
        future: _futureWfh,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
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
                          // TextField(
                          //   controller: dateinput, //editing controller of this TextField
                          //   decoration: InputDecoration(
                          //       labelText: "Date" //label text of field
                          //       ),
                          //   readOnly:
                          //       true, //set it true, so that user will not able to edit text
                          //   onTap: () async {
                          //     DateTime? date = await showDatePicker(context: context,
                          //       initialDate: new DateTime.now(),
                          //       firstDate: new DateTime(2016),
                          //       lastDate: new DateTime(2024),
                          //     );
                          //       if(date != null) print(date);
                          //   }
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
                            activeColor: Config().grey3,
                            onChanged: (val) {
                              // setState(() {
                              //   id = 1;
                              // });
                            },
                          ),
                          Text(
                            'Fullday',
                            style: new TextStyle(fontSize: 15.0),
                          ),
              
                          Radio(
                            value: 2,
                            groupValue: id,
                            activeColor: Config().grey3,
                            onChanged: (val) {
                              // setState(() {
                              //   id = 2;
                              // });
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
                                            _launchUrlPlaystore();
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
                                        readOnly: i < 2? true : false,
                                        controller: linksController[i], //editing controller of this TextField
                                        decoration: InputDecoration(
                                          suffixIcon: i < 2? SizedBox(): GestureDetector(
                                            onTap: (){
                                              linksController.removeAt(i);
                                        setState(() {});
                                            },
                                            child: Image.asset("assets/delete.png", scale: 2.3,)),
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
                                activeColor: Config().grey3,
                                onChanged: (val) {
                                  // setState(() {
                                  //   conditionId = 1;
                                  // });
                                },
                              ),
                              Text(
                                'Normal',
                                style: new TextStyle(fontSize: 15.0),
                              ),
                    
                              Radio(
                                value: 2,
                                groupValue: conditionId,
                                activeColor: Config().grey3,
                                onChanged: (val) {
                                  // setState(() {
                                  //   conditionId = 2;
                                  // });
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
                                activeColor: Config().grey3,
                                onChanged: (val) {
                                  // setState(() {
                                  //   conditionId = 3;
                                  // });
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
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        }
      ),
    );
  }

  // -- API --
  Future<void> getDataWfh()async{
    _wfh = await DetailWFHApi.getData(context, widget.id!);
    print('wfh');
    print(_wfh![0].request_link);
    for (var e in _wfh![0].request_link!) {
      // print(e['link']);
      linksController.insert(0,TextEditingController(text: e['link']));
    }
    setState(() {
      lengthLinks = linksController.length;
    });
    // linksController.add(value)
  }

}

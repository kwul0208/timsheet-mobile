import 'dart:async';
import 'dart:convert';
// import 'dart:html';

import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/WFH/WFHModel.dart';
import 'package:timsheet_mobile/Models/WFH/detail/DetailWFHApi.dart';
import 'package:timsheet_mobile/Models/WFH/detail/DetailWFHModel.dart';
import 'package:timsheet_mobile/Provider/WFH/WFHState.dart';
import 'package:timsheet_mobile/Routing/SlideRightRoute.dart';
import 'package:timsheet_mobile/Widget/Badge.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/CancelWFHForm.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/EditWFH.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher_string.dart';


class DetailWFH extends StatefulWidget {
  const DetailWFH({super.key, this.id, this.description, this.date, this.start_hour, this.finish_hour, this.duration, this.condition, this.status_id, this.is_overtime, this.wfh, this.secondView,});
  final int ? id;
  final String ? description;
  final String ? date;
  final String ? start_hour;
  final String ? finish_hour;
  final String ? duration;
  final String ? condition;
  final int ? status_id;
  final int ? is_overtime;
  final List<WFHModel> ? wfh;
  final dynamic secondView;
  

  @override
  State<DetailWFH> createState() => _DetailWFHState();
}

class _DetailWFHState extends State<DetailWFH> {

    // status loading
  bool _isLoading = false;
  String _isStatus = 'false';
  // endStatus loading

  
  List<AppInfo>? installedApps;
  List<AppInfo> iOSApps = [
    AppInfo(appName: "Calendar", packageName: "calshow://"),
    AppInfo(appName: "Facebook", packageName: "fb://"),
    AppInfo(appName: "Whatsapp", packageName: "whatsapp://"),
  ];
  
  List<DetailWFHModel>? _wfh;
  Future<dynamic>? _futureWfh;

  @override
  void initState(){
    super.initState();
    getApps();

    _futureWfh = getDataWfh();
  }

  _showConfirm(int id) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            // title: Text("Delete"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline),
                      Text(
                        "Delete",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10,),
                  _isStatus == 'false'
                      ? Text("Are you sure want to delete your RWD?",style: TextStyle(fontSize: 16),)
                      : _isStatus == 'load'
                          ? Center(child: CircularProgressIndicator())
                          : _isStatus == 'success'
                              ? Center(
                                  child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 50,
                                      color: Color.fromRGBO(47, 158, 95, 1),
                                    ),
                                    Text('Success')
                                  ],
                                ))
                              : SizedBox(),
                ],
              ),
            ),
            actions: <Widget>[
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _isStatus == 'false'
                        ? TextButton(
                            child: const Text('ok', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),),
                            onPressed: () {
                              setState(() {
                                _isStatus = 'load';
                              });
                              
                              deleteRWD(id).then((value) {
                                if (value['status'] == true) {
                                  setState(() {
                                    _isStatus = 'success';
                                  });
                                  Timer(Duration(seconds: 1), () {
                                    Navigator.pop(context);
                                    widget.wfh?.removeWhere((e) => e.id == id);
                                    Provider.of<WFHState>(context,listen: false).changeRefresh();
                                    setState(() {
                                      _isStatus = 'false';
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          "Success"),
                                          duration: Duration(seconds: 4)
                                    ));
                                    Navigator.pop(context, true);
                                  });
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                    _isStatus = 'false';
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Failed! try again later please."),
                                        duration: Duration(seconds: 4),
                                  ));
                                }
                              });
                            },
                          )
                        : SizedBox(),
                    _isStatus == 'false'
                        ? TextButton(
                            child: const Text('cancel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        : SizedBox(),
                    ],
                  )
                ],
              ),
              
            ],
          );
        });
      },
    );
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
  // final Uri _url = Uri.parse('https://tasks.office.com/muc.co.id/en-US/Home/Planner/#/mytasks');
  Future<void> _launchUrl(_url) async {
      if (!await launchUrl(Uri.parse(_url), mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $_url');
      }
    }

  // --- launch playstore(download planner)
  final Uri _urlPlaystore = Uri.parse('https://play.google.com/store/apps/details?id=com.microsoft.planner');
  Future<void> _launchUrlPlaystore() async {
      if (!await launchUrl(_urlPlaystore, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $_urlPlaystore');
      }
  }


  @override
  Widget build(BuildContext context) {
    var size, height, width;

    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Consumer<WFHState>(
      builder: (context, data, _) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                title: const Text("RWD Detail",
                    style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
                centerTitle: false,
                leading: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Image.asset("assets/x.png", scale: 2,)),
                actions:  [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Row(
                      children: [
                        widget.status_id == 1 ?
                        GestureDetector(
                          onTap: (){
                            _showConfirm(widget.id!);
                          },
                          child: Image.asset("assets/delete.png", scale: 2,)) : SizedBox(),
                        SizedBox(width: 4,),
                        widget.status_id == 1 || widget.status_id == 2 || widget.status_id == 4 ?
                        GestureDetector(
                          onTap: (){
                            widget.secondView(EditWFH(id: widget.id, date: widget.date, duration: widget.duration, condition: widget.condition, description: widget.description, startTime: widget.start_hour, finishTime: widget.finish_hour, fromEdit: true, status_id: widget.status_id,));
                          },
                          child: Image.asset("assets/edit_active.png", scale: 2,)) : SizedBox(),
                        SizedBox(width: 4,),
                        widget.status_id == 2 ?
                        GestureDetector(
                            onTap: ()async{
                                    Provider.of<WFHState>(context, listen: false).changeLoadDone(true);
                                    await doneRWD(widget.id).then((value) async {
                                      if (value['status'] == true) {
                                       
                                        Timer(Duration(milliseconds: 300), () {
                                          widget.wfh?.removeWhere((e) => e.id == widget.id);
                                          Provider.of<WFHState>(context,listen: false).changeRefresh();
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                                "Success"),
                                                duration: Duration(seconds: 4)
                                          ));
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(
                                              "Failed! try again later please."),
                                              duration: Duration(seconds: 4),
                                        ));
                                      }
                                    });
                                    Provider.of<WFHState>(context, listen: false).changeLoadDone(false);
                                    await Future.delayed(Duration(seconds: 1));
                                    Navigator.pop(context);
                            },
                          child: Image.asset("assets/check_rounded.png", scale: 1.7,)) : SizedBox(),
                        SizedBox(width: 4,),
                        widget.status_id == 2 ?
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CancelWFHForm(id: widget.id, wfh: widget.wfh, date: widget.date,)));
                          },
                          child: Icon(Icons.do_not_disturb_on_total_silence_outlined, size: 30, color: Config().redPallet,)) : SizedBox(),
                        SizedBox(width: 8,),
                      ],
                    ),
                  ),
                ],
              ),
              body: FutureBuilder(
                future: _futureWfh,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(
                              builder: (context) {
                                DateTime dt = DateTime.parse("${_wfh![0].date}");
                                String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                                return Text("${formattedDate}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Config().orangePallet),);
                              }
                            ),
                            SizedBox(height: 10,),
                            widget.is_overtime == 1 ? Badge(title: "Overtime", color: Config().blue2) : SizedBox(),
                            SizedBox(height: 3,),
                            Builder(
                              builder: (context) {
                                if(widget.status_id == 1){
                                  return Badge(title: "Pending", color: Config().orangePallet,);
                                }else if (widget.status_id == 2) {
                                  DateTime dt = DateTime.parse("${_wfh![0].approved_date}");
                                  String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Config().blue2
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8, top: 8, right: 40, bottom: 8),
                                      child: Text("${_wfh![0].status!['status_name']}\nby ${_wfh![0].approved_by!['fullname']}\nat ${formattedDate}", style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),)
                                        
                                    ),
                                  );
                                } else if(widget.status_id == 3) {
                                  DateTime dt = DateTime.parse("${_wfh![0].rejected_date}");
                                  String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Config().redPallet
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8, top: 8, right: 40, bottom: 8),
                                      child: Text("${_wfh![0].status!['status_name']}\nby ${_wfh![0].rejected_by!['fullname']}\nat ${formattedDate}", style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),)
                                        
                                    ),
                                  );
                                }else if(widget.status_id == 4){
                                  return Badge(title: "Need Verification", color: Config().orangePallet,);
                                }else if(widget.status_id == 5){
                                  return Badge(title: "Verified", color: Config().bgLock,);
                                }else if(widget.status_id == 6){
                                  return Badge(title: "Cancel", color: Color.fromRGBO(172, 172, 172, 1),);
                                }{
                                  return SizedBox();
                                }
                                
                              }
                            ),
                            SizedBox(height: 16,),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Duration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, .64)),),
                                        SizedBox(width: 30,),
                                        Text("Time", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, .64)),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            if (widget.duration == 'full_day') {
                                              return Text("Full Day", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                            } else{
                                              return Text("Half Day", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                            }
                                          }),
                                        SizedBox(width: 30,),
                                        Builder(
                                          builder: (context) {
                                            if (widget.duration == "full_day") {
                                              return Text("-", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                            }else{
                                              return Text("${widget.start_hour.toString().substring(0,5)} - ${widget.finish_hour.toString().substring(0,5)}");
                                            }
                                          }
                                    ),
                                      ],
                                    )
                                  ],
                                ),

                              ],
                            ),
                            SizedBox(height: 16,),
                            Text("Description", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, .64)),),
                            Text("${_wfh![0].description}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
                            SizedBox(height: 16,),
                            Text("links", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, .64)),),
                            SizedBox(height: 6,),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _wfh![0].request_link!.length,
                              itemBuilder: (context, i) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset("assets/mdi_link-variant.png", scale: 2,),
                                    SizedBox(width: 10,),
                                    Flexible(child: GestureDetector(
                                      onTap: (){
                                          getApps().then((value)async{
                                            if (value == true) {
                                              _launchUrl("${_wfh![0].request_link![i]['link']}");
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
                                      child: Text("${_wfh![0].request_link![i]['link']}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)))),
                                  ],
                                );
                              }
                            )
                          ],
                        ),
                      ),
                    );
                  }else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              ),
            ),
            data.loadDone == true ? Container(
                width: width,
                height: height,
                color: Color.fromARGB(78, 0, 0, 0),
                child: Center(
                  child: CircularProgressIndicator(),)) : SizedBox()
          ],
        );
      }
    );
  }

  // -- API --
  Future<void> getDataWfh()async{
    _wfh = await DetailWFHApi.getData(context, widget.id!);
    print('wfh');
    print(_wfh);
  }

  Future deleteRWD(id)async{
    try {
      final storage = new FlutterSecureStorage();
      var employees_id = await storage.read(key: 'employees_id');
      
      var request = http.Request('DELETE', Uri.parse('http://103.115.28.155:1444/form_request/api/rwd/employees/$employees_id/destroy/$id'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var x = await response.stream.bytesToString();
        Map data = jsonDecode(x);
        if (data['code'] == 200) {
          print('20000');
          return {"status": true, "message": "success"};
        }else{
          print('30000');
          return {"status": false, "message": "${data['code']}"};
        }
      }
      else {
          print('40000');
        return {"status": false, "message": "${response.reasonPhrase}"};
      }
    } catch (e) {
      print(e);
      print('50000');
      return {"status": false, "message": "${e}"};
    }
    
  }

  Future doneRWD(id)async{
    // await Future.delayed(Duration(seconds: 3));
    // return {"status": true, "message": "success"};

    try {
      final storage = new FlutterSecureStorage();
      var employees_id = await storage.read(key: 'employees_id');
      
      var request = http.Request('PUT', Uri.parse('http://103.115.28.155:1444/form_request/api/rwd/employees/$employees_id/done/$id'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var x = await response.stream.bytesToString();
        Map data = jsonDecode(x);
        if (data['code'] == 200) {
          print('20000');
          return {"status": true, "message": "success"};
        }else{
          print('30000');
          return {"status": false, "message": "${data['code']}"};
        }
      }
      else {
          print('40000');
        return {"status": false, "message": "${response.reasonPhrase}"};
      }
    } catch (e) {
      print(e);
      print('50000');
      return {"status": false, "message": "${e}"};
    }
    
  }


}